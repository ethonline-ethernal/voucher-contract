import { ethers } from 'hardhat'
import hre from 'hardhat'

async function main() {
  //deploy here

  const URI =
    'https://storageapi.fleek.co/86373b43-dff7-47cd-b7a5-45d00050f41f-bucket/metadata/'

  const tokenGatedAddress = '0x2F341737d7D9A126EC86a9d5168a34Fd06Bbd156'

  // --- Deploy Factory ---

  const Factory = await hre.ethers.getContractFactory('Factory')
  const factory = await Factory.deploy()
  await factory.deployed()
  console.log('Factory deployed to:', factory.address)
  await factory.createVoucher('Alice', 'BOB', URI, 50)
  await factory.createTokenGatedVoucher(
    'CAROL',
    'DAVE',
    URI,
    50,
    tokenGatedAddress,
  )

  await new Promise((resolve) => setTimeout(resolve, 10000))

  const Voucher = await hre.ethers.getContractFactory('Voucher')
  const voucher = await Voucher.attach(await factory.getVoucherAddress('Alice'))
  await voucher.mint('0xCfc597a8793E0ca94FC8310482D9e11367cfCA24')

  const TokenGatedVoucher = await hre.ethers.getContractFactory(
    'TokenGatedVoucher',
  )
  const tokenGatedVoucher = await TokenGatedVoucher.attach(
    await factory.getVoucherAddress('CAROL'),
  )
  await tokenGatedVoucher.mint('0xCfc597a8793E0ca94FC8310482D9e11367cfCA24', 1)

  await new Promise((resolve) => setTimeout(resolve, 10000))

  await voucher.redeem('0xCfc597a8793E0ca94FC8310482D9e11367cfCA24')
  await tokenGatedVoucher.redeem(
    '0xCfc597a8793E0ca94FC8310482D9e11367cfCA24',
    1,
  )

  // ----------------------------- Token Gated -----------------------------

  // const TokenGatedVoucher = await hre.ethers.getContractFactory(
  //   'TokenGatedVoucher',
  // )
  // const tokengatedvoucher = await TokenGatedVoucher.deploy(
  //   'Alice',
  //   'BOB',
  //   URI,
  //   50,
  //   tokenGatedAddress,
  // )
  // await tokengatedvoucher.deployed()

  // console.log('TokenGatedVoucher deployed to:', tokengatedvoucher.address)

  // tokengatedvoucher.giveAccessToVault(
  //   '0xCfc597a8793E0ca94FC8310482D9e11367cfCA24',
  // )
  // tokengatedvoucher.mint('0xCfc597a8793E0ca94FC8310482D9e11367cfCA24', 1)

  // await new Promise((resolve) => setTimeout(resolve, 10000))

  // ----------------------------- Free Mint --------------------------------

  // const Voucher = await hre.ethers.getContractFactory('Voucher')
  // const voucher = await Voucher.deploy('Ethernal Voucher', 'ETHERNAL', URI, 50)
  // await voucher.deployed()
  // console.log('Voucher deployed to:', voucher.address)

  // await voucher.giveAccessToVault('0xCfc597a8793E0ca94FC8310482D9e11367cfCA24')

  // await voucher.mint('0xCfc597a8793E0ca94FC8310482D9e11367cfCA24')

  // await new Promise((resolve) => setTimeout(resolve, 10000))

  // ----------------------------- Verify --------------------------------

  await hre.run('verify:verify', {
    address: factory.address,
    constructorArguments: [],
  })

  // await hre.run('verify:verify', {
  //   address: voucher.address,
  //   constructorArguments: ['Ethernal Voucher', 'ETHERNAL', URI, 50],
  // })

  // await hre.run('verify:verify', {
  //   address: tokengatedvoucher.address,
  //   constructorArguments: ['Alice', 'BOB', URI, 50, tokenGatedAddress],
  // })
}
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
