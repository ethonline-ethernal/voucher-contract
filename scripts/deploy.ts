import { ethers } from 'hardhat'
import hre from 'hardhat'

async function main() {
  //deploy here

  const URI =
    'https://storageapi.fleek.co/86373b43-dff7-47cd-b7a5-45d00050f41f-bucket/metadata/'

  const Factory = await hre.ethers.getContractFactory('Factory')
  const factory = await Factory.deploy()
  await factory.deployed()
  console.log('Factory deployed to:', factory.address)

  await new Promise((resolve) => setTimeout(resolve, 10000))

  const Voucher = await hre.ethers.getContractFactory('Voucher')
  const voucher = await Voucher.deploy('Ethernal Voucher', 'ETHERNAL', URI, 50)
  await voucher.deployed()
  console.log('Voucher deployed to:', voucher.address)

  // await voucher.mint("0xCfc597a8793E0ca94FC8310482D9e11367cfCA24");

  await new Promise((resolve) => setTimeout(resolve, 10000))

  await hre.run('verify:verify', {
    address: factory.address,
    constructorArguments: [],
  })

  await hre.run('verify:verify', {
    address: voucher.address,
    constructorArguments: ['Ethernal Voucher', 'ETHERNAL', URI, 50],
  })
}
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
