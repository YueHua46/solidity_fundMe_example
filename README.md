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

## chainlink

chainlink系统能够帮助链上智能合约完成链下与真实世界的交互
通常，智能合约是部署在以太坊区块链中的一个去中心化自动化程序，其本身并不具备能够和真实世界交互（既
获取某个货币的价值或今天的天气或股票信息等）
那么为了能够获得链下真实世界的信息，我们便需要通过ChainLink来做到

### ChainLink喂价

ChainLink喂价是一种基于ChainLink网络的预言机服务，它可以为智能合约提供可靠的链外数据，例如各种加密货币的价格。ChainLink喂价的特点是在数据源、节点运营商和预言机网络层面都实现了数据聚合，因此可以提高数据的质量和安全性.

ChainLink喂价的工作原理是，ChainLink网络中的多个节点运营商从不同的数据源获取数据，然后通过加权平均的方式计算出一个**聚合价格**，这个价格会被存储在一个代理合约中，供智能合约调用。ChainLink喂价的更新频率取决于数据的波动程度，当数据超过一定的偏差阈值时，就会触发更新.

ChainLink喂价目前已经支持了多条链，包括Ethereum、BSC、Heco、Avalanche等EVM链，以及Solana和Terra等非EVM链。ChainLink喂价也支持多种交易对，包括加密货币、法币、商品、股票等。ChainLink喂价已经成为了DeFi经济中最主流且最安全的链上价格数据源，在链上保障着数十亿美元的价值.

ChainLink喂价的整个流程涉及以下几个步骤：

创建智能合约：首先，您需要创建一个智能合约，并在合约中引入Chainlink的AggregatorV3Interface接口。这个接口允许您的合约与Chainlink预言机进行交互，以获取最新的价格数据。

初始化价格Feed：在智能合约的构造函数中，您需要初始化一个AggregatorV3Interface类型的变量，这个变量将用来与特定的价格Feed进行交互。

获取最新价格：通过调用AggregatorV3Interface接口的latestRoundData方法，您的合约可以获取到最新的价格数据。

以下是一个简单的示例代码，展示了如何在Solidity中使用Chainlink喂价功能：
```sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Sepolia
     * Aggregator: BTC/USD
     * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
     */
    constructor() {
        priceFeed = AggregatorV3Interface(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43);
    }

    /**
     * 返回最新的价格
     */
    function getLatestPrice() public view returns (int) {
        (
            /* uint80 roundID */,
            int price,
            /* uint startedAt */,
            /* uint timeStamp */,
            /* uint80 answeredInRound */
        ) = priceFeed.latestRoundData(); // 使用latestRoundData方法返回最新的dataFeed
        return price;
    }
}
```
在这个示例中，我们创建了一个名为PriceConsumerV3的合约，它使用Chainlink的Kovan测试网络上的ETH/USD价格Feed。合约中的getLatestPrice函数可以返回最新的ETH/USD价格1

请注意，您需要根据您的具体需求，选择正确的价格Feed地址，并将其替换到示例代码中的相应位置。您可以在Chainlink的官方文档中找到不同链上支持的价格Feed地址2

### ChainLink VRF

ChainLink VRF是一种基于ChainLink网络的可验证随机函数服务，它可以为智能合约提供可靠的链外随机数，而不影响安全性或可用性。ChainLink VRF的原理是，**每个随机数请求，ChainLink VRF都会生成一个或多个随机数和相应的加密证明，证明这些随机数是如何确定的**。这个证明会在区块链上公开发布和验证，以确保结果不会被任何人包括预言机运营商、矿工、用户或智能合约开发者篡改或操纵.

ChainLink VRF的应用场景包括区块链游戏和NFT、随机分配资源和任务、选择代表性样本、生成随机事件等。

ChainLink VRF目前已经支持了多条链，包括Ethereum、BSC、Heco、Avalanche等EVM链，以及Solana和Terra等非EVM链。ChainLink VRF也提供了两种请求随机数的方法：订阅和直接支付，根据不同的使用场景，可以选择更合适的方法.

根据我搜索到的结果，Chainlink VRF请求随机数的方法有两种：

- 订阅：这种方法是通过一个订阅合约，定期向VRF合约发送请求，每次请求都会消耗一定数量的LINK代币。订阅合约可以设置请求的间隔时间、最大请求数量、种子值等参数。这种方法适合需要频繁或定期获取随机数的场景，例如每周抽奖、每日任务等.

- 直接支付：这种方法是通过一个支付合约，直接向VRF合约发送请求，每次请求都会支付一定数量的LINK代币。支付合约可以设置请求的种子值、回调函数等参数。这种方法适合需要灵活或不确定获取随机数的场景，例如用户触发的事件、随机奖励等.

要在您的智能合约中应用ChainLink VRF，您需要按照以下步骤操作：

引入ChainLink VRF合约：首先，您需要在智能合约中引入ChainLink VRF的接口和库。这通常通过导入Chainlink提供的VRFConsumerBase合约来完成。

继承VRFConsumerBase合约：您的合约需要继承VRFConsumerBase合约，并实现必要的构造函数。

设置VRF订阅和费用：您需要设置一个VRF订阅，并为其充值LINK代币，以支付随机数请求的费用。

请求随机数：在合约中，您将调用requestRandomness函数来请求随机数。这个函数需要两个参数：keyHash（表示VRF密钥对的唯一标识符）和fee（支付给Oracle的LINK代币数量）。

实现回调函数：当Oracle响应您的随机数请求时，它会调用您合约中的fulfillRandomness函数。您需要在这个函数中实现您的逻辑，以处理接收到的随机数。

以下是一个简单的示例，展示了如何在Solidity中集成ChainLink VRF：

```sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract RandomNumberConsumer is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;

    /**
     * 构造函数
     */
    constructor() 
        VRFConsumerBase(
            0xf0d54349aDdcf704F77AE15b96510dEA15cb7952, // VRF Coordinator
            0x514910771AF9Ca656af840dff83E8264EcF986CA  // LINK Token
        ) public
    {
        keyHash = 0x6c3699283bda56ef852e691bd5d5e592de89f6b8;
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    }

    /**
     * 请求随机数
     */
    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    /**
     * 接收随机数
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
    }
}
```
在这个示例中，RandomNumberConsumer合约继承了VRFConsumerBase，并实现了请求和接收随机数的功能。请注意，您需要根据您的链和需求，替换合约中的VRF Coordinator地址和LINK Token地址。