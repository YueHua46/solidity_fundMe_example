// 编写一个测试，能够测试FundMe合约中fund函数的功能，具体测试其转账额度是否为1Eth

// truffle提供了一些全局变量，比如artifacts，contract，accounts等
/**
 * artifacts: 用于获取编译后的合约的抽象接口，可以通过artifacts.require("合约名")来获取
 * contract: 用于编写测试用例，可以通过contract("合约名",() => {})来编写测试用例
 * accounts: 用于获取当前网络的所有账户，可以通过accounts[0]来获取第一个账户
 */
const FundMe = artifacts.require("FundMe")

contract("FundMe",(accounts) => {
  it("交易余额是否大于1Eth",  async () => {
    // 访问合约实例，通过deployed方法获得
    const fundMe = await FundMe.deployed()


    // 通过以下方式获取合约的公共变量
    // const addressToAmountFunded = await fundMe.addressToAmountFunded.call()
    // console.log('addressToAmountFunded',addressToAmountFunded)
    

    // 调用fund函数，向合约转账1Eth
    await fundMe.fund({
      from: accounts[0],
      // value默认单位为wei，1Eth = 10^18 wei
      value: 1
    })
  })
})