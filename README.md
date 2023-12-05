## truffle test


truffle test相关文章推荐

> https://dev.to/kevinmaarek/testing-your-smart-contract-with-truffle-3g6f

## revert

什么是revert？实际上在合约中如果合约执行遇到错误或不满足某些条件时，可以调用revert来停止执行并撤销所有状态的改变；
revert可以主动执行，也会隐式的自动执行。

### 主动执行revert示例

```sol
function buy(uint256 amount) public {
    if (amount > availableInventory) {
        revert("Not enough inventory available");
    }
    // ...
}
```

### 隐式执行revert示例

```sol
contract Test {
    uint public num;

    function fund() public payable {
      // 执行一个操作
      num = 5;
      // 使用require来测试10是否大于11，很明显会false，那么便会触发revert
      // 在这个fund函数内的所有操作都会被“撤销”，包括 num = 5;
      require(10 > 11,"10不大于11");
    }
}
```