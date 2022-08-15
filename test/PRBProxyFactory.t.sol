// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { console2 } from "forge-std/console2.sol";
import { PRBProxyFactory } from "../src/PRBProxyFactory.sol";

import { TestBase } from "./TestBase.t.sol";

contract PRBProxyFactoryTest is TestBase {
    /*//////////////////////////////////////////////////////////////////////////
                                       EVENTS
    //////////////////////////////////////////////////////////////////////////*/
    event DeployProxy(
        address indexed origin,
        address indexed deployer,
        address indexed owner,
        bytes32 seed,
        bytes32 salt,
        address proxy
    );

    /*//////////////////////////////////////////////////////////////////////////
                                      CONSTANTS
    //////////////////////////////////////////////////////////////////////////*/
    bytes32 internal constant SEED_ONE = bytes32(uint256(0x01));
    bytes32 internal constant SEED_ZERO = bytes32(uint256(0x00));

    /*//////////////////////////////////////////////////////////////////////////
                                  TESTING VARIABLES
    //////////////////////////////////////////////////////////////////////////*/
    address internal deployer;
    PRBProxyFactory internal prbProxyFactory = new PRBProxyFactory();

    /*//////////////////////////////////////////////////////////////////////////
                                   SETUP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev A setup function invoked before each test case.
    function setUp() public override {
        super.setUp();
        deployer = users.alice;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                        TESTS
    //////////////////////////////////////////////////////////////////////////*/
    /// @dev it should emit a DeployProxy event.
    function testDeploy__Event() external {
        vm.expectEmit(true, true, true, true);
        bytes32 salt = keccak256(abi.encode(deployer, SEED_ZERO));
        bytes memory deploymentBytecode = vm.getCode("PRBProxy.sol:PRBProxy");
        bytes32 deploymentBytecodeHash = keccak256(abi.encode(deploymentBytecode));
        console2.logBytes32(salt);
        console2.logBytes32(deploymentBytecodeHash);
        console2.logAddress(address(prbProxyFactory));
        address proxyAddress = computeCreate2Address(salt, deploymentBytecodeHash, address(prbProxyFactory));
        console2.logAddress(proxyAddress);
        console2.log("###################");
        emit DeployProxy(deployer, deployer, deployer, SEED_ZERO, salt, proxyAddress);
        prbProxyFactory.deploy();
    }
}
