// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

/**
 * 实现一个简单的众筹合约
 * 需要具备以下功能：
 *  1. 众筹者可以向合约中捐款
 *  2. 众筹者可以查看自己捐款的金额
 *  3. 合约管理员可以查看合约中已筹集的金额
 *  4. 合约管理员可以提取合约中的金额
 *  5. 以usd为计价单位，合约管理员可以设置众筹的最小捐款金额
 */

// 定义一个枚举类型，用来表示计价单位
enum Unit {
  Wei,
  Gwei,
  Ether
}


contract FundMe {

    // 定义一个mapping，用来存储捐款人地址和捐款金额的映射关系
    mapping(address => uint256) public addressToAmountFunded;
    // 定义最小计价单位为1Eth
    uint minmumPricing = 1; 


    // 定义一个函数，用来接收捐款
    // 使用payable关键字，表示这个函数可以接收以太币
    function fund() public payable {
      // msg.value表示捐款的金额，单位为wei
      // msg.sender表示捐款人的地址

      // 当交易的金额小于最小计价单位时，抛出异常
      require(msg.value >= conversionUnit(Unit.Ether,minmumPricing), unicode"这个金钱额数太小了！最少需要1Eth");
      addressToAmountFunded[msg.sender] += msg.value;
    }

    function conversionUnit(Unit _unit,uint _amout) public pure returns(uint) {
      if (_unit == Unit.Wei) {
        return _amout;
      } else if (_unit == Unit.Gwei) {
        return _amout * 1e9;
      } else if (_unit == Unit.Ether) {
        return _amout * 1e18;
      } else {
        return 0;
      }
    }

}