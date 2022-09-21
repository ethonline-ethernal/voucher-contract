compile: 
	npx hardhat compile

chain:	
	npx hardhat node

deploy-rinkeby:
	npx hardhat run scripts/deploy.ts --network rinkeby

deploy:
	npx hardhat run scripts/deploy.ts --network localhost

deploy-ropsten:
	npx hardhat run scripts/deploy.ts --network ropsten

deploy-mumbai:
	npx hardhat run scripts/deploy.ts --network mumbai

deploy-polygon:
	npx hardhat run scripts/deploy.ts --network polygon
