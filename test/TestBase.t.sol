// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Cheats, Utils } from "forge-std/Components.sol";
import { console } from "forge-std/console.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract TestBase is PRBTest, Cheats, Utils {
    /*//////////////////////////////////////////////////////////////////////////
                                       STRUCTS
    //////////////////////////////////////////////////////////////////////////*/

    struct Users {
        address payable alice;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                  TESTING VARIABLES
    //////////////////////////////////////////////////////////////////////////*/

    Users internal users;

    /*//////////////////////////////////////////////////////////////////////////
                                   SETUP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev A setup function invoked before each test case.
    function setUp() public virtual {
        // Create 3 users for testing. Order matters.
        users = Users({ alice: mkaddr("Alice") });
        vm.deal(users.alice, 100 ether);
        vm.startPrank(users.alice, users.alice);
    }

    /*//////////////////////////////////////////////////////////////////////////
                                  UTILITY FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Generates an address by hashing the name and labels the address.
    function mkaddr(string memory name) internal returns (address payable addr) {
        addr = payable(address(uint160(uint256(keccak256(abi.encodePacked(name))))));
        vm.label(addr, name);
    }
}
