pub mod bindings;

#[cfg(test)]
mod tests {
    use alloy::{
        network::EthereumWallet,
        node_bindings::Anvil,
        primitives::U256,
        providers::{Provider, ProviderBuilder},
        signers::local::PrivateKeySigner,
    };

    use crate::bindings::{erc20logger::ERC20Logger, exampletoken::ExampleToken};

    #[tokio::test]
    async fn test_transfer() -> Result<(), Box<dyn std::error::Error>> {
        // Spin up local Anvil node
        let anvil = Anvil::new().try_spawn()?;

        let signer: PrivateKeySigner = anvil.keys()[0].clone().into();
        let wallet = EthereumWallet::from(signer);

        let provider = ProviderBuilder::new()
            .with_recommended_fillers()
            .wallet(wallet)
            .on_http(anvil.endpoint().parse()?);

        println!("Anvil running at `{}`", anvil.endpoint());

        // Deploy contracts
        let logger = ERC20Logger::deploy(&provider).await?;
        let token = ExampleToken::deploy(&provider).await?;

        let amount = U256::from(10e18);
        let recipient = anvil.addresses()[1];
        let metadata = "test metadata".to_string();

        // Approve transfer
        token
            .approve(*logger.address(), amount)
            .send()
            .await?
            .watch()
            .await?;

        // Transfer
        let tx_hash = logger
            .transferWithMetadata(*token.address(), recipient, amount, metadata.clone())
            .send()
            .await?
            .watch()
            .await?;

        let receipt = provider
            .get_transaction_receipt(tx_hash)
            .await?
            .expect("no receipt");

        let events = receipt
            .inner
            .logs()
            .iter()
            .filter_map(
                |log| match log.log_decode::<ERC20Logger::MetadataLogged>() {
                    Ok(event) => Some(event),
                    Err(_) => None,
                },
            )
            .collect::<Vec<_>>();

        assert_eq!(events.len(), 1);

        let event = events.first().unwrap();

        assert_eq!(event.inner.from, anvil.addresses()[0]);
        assert_eq!(event.inner.to, recipient);
        assert_eq!(event.inner.token, *token.address());
        assert_eq!(event.inner.amount, amount);
        assert_eq!(event.inner.metadata, metadata);

        Ok(())
    }
}
