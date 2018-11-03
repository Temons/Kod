pragma solidity ^0.4.19;

contract Ownable{

   address owner; 
   
   function Ownable() public {
        owner = msg.sender;
   }
  
   modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract XXXtoken is Ownable {

string public name;
    
string public symbol;
    
uint8 public decimals;
    
uint256 public totalSupply;

uint256 public sellPrice;

uint256 public buyPrice;


    // transaction storage
    mapping (address=>uint256) public balanceOf;
    
    // storage of approved transactions
    mapping (address=>mapping(address=>uint256)) public allowance;
    
    // event to log transfer of tokens
    event Transfer (address indexed from, address indexed to, uint256 value);
    // event for logging tokens transfer approval
    event Approval (address indexed from, address indexed to, uint256 value);
    // event for logging tokens burning
    event Burn (address indexed burner, uint indexed value);
    
    // contract initialization function
    function XXXtoken() public {
        name = "X X X";  
        
        symbol = "XXX";
        
        decimals = 8;
       
        totalSupply = 1000000000*(10**uint256(decimals));
        
        buyPrice = 100000; // 1eth = 100.000 tokens

        sellPrice = 99800;
        
        // all tokens to contract creator
        balanceOf[msg.sender] = totalSupply;
        emit Transfer (address(0), msg.sender, totalSupply);
    }
    
    // internal function to transfer tokens
   function _transfer (address _from, address _to, uint256 _value) internal{
    require (_to != 0x0);
    require (balanceOf[_from] >= _value);
    // overflow check
    require(balanceOf[_to] + _value >= balanceOf[_to]);
    balanceOf[_from] -= _value;
    balanceOf [_to] += _value;
    // event Transfer
    emit Transfer (_from, _to, _value);
    }
    
    // funds receiving function
    function () payable public {
        uint amount = msg.value / buyPrice;
        _transfer(this, msg.sender, amount);
    }

    // tokens purchase function from contract
    function buy() payable public {
        uint amount = msg.value / buyPrice;
        _transfer(this, msg.sender, amount);
        
    }
    
    // tokens selling function
    function sell(uint256 amount) public {
        // checks if the contract has enough ether to buy
        require(this.balance >= amount * sellPrice);    
        // makes the transfers  
        _transfer(msg.sender, this, amount);              
        msg.sender.transfer(amount * sellPrice);
    }
    
    
    // function to transfer approved tokens
   function transferFrom (address _from, address _to, uint256 _value) public {
   require (_value <= allowance[_from][_to]);
   allowance [_from][_to]-= _value;
   _transfer(_from,_to, _value);
   }

   // function to approve tokens transfer
   function Approve (address _to, uint256 _value) public {
    allowance [msg.sender][_to] = _value;
    // event for logging tokens transfer approval
    emit Approval(msg.sender, _to, _value);
   }
   
   // function that burns an amount of the token
   function burn(uint _value) public onlyOwner  {
    require(_value > 0);
    balanceOf[msg.sender] = balanceOf[msg.sender] - _value;
    totalSupply = totalSupply - _value;
    emit Burn(msg.sender, _value);
}


    // Function for tokens
    function transfer (address _to,uint256 _value) public{
        // internal transfer function
        _transfer(msg.sender, _to, _value);
    }

    // prices change
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }
    
    
    function withdraw() public onlyOwner {
        owner.transfer(this.balance);
    }
}
