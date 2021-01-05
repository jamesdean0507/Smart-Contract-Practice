// SPDX-License-Identifier: Unliscenced
pragma solidity ^0.6.0;

contract HotelRoom {
    
    enum Statuses {Vacant, Occupied} //Enumeration, Vacant or Occupied traits for a room.
    Statuses currentStatus;
    
    event Occupy(address _occupant, uint value);
    
    address payable public owner; //State Variable, reciever of payment when room is booked
    
    constructor() public
    {
        owner = msg.sender;
        currentStatus = Statuses.Vacant;
    }
    
    modifier onlyWhileVacant 
    {
        require(currentStatus == Statuses.Vacant, "ERROR: Currently Occupied."); //Check Status of room.
        _;
    }
    
    modifier costs(uint _amount)
    {
        require(msg.value >= _amount, "ERROR: Not enough ether provided"); //Check status of payment.
        _;
    }
    
    receive() external payable onlyWhileVacant costs(2 ether)
    {
        currentStatus = Statuses.Occupied;
        owner.transfer(msg.value);
        emit Occupy(msg.sender, msg.value);
    }
    
}