pragma solidity ^0.6.6;

 import "./IERC20.sol";
 import "./SafeMath.sol";
 
 contract myCapERC is IERC20  {
     
     using SafeMath for uint256;
     //mapping to hold balances against EOA accounts "only in this case"
     mapping (address => uint256) public _balances;
     
     //mapping allowance
     //keeps track of the allowances with a two-dimensional mapping
     //priamry key "address of the owner", then mapping to a "spender address" and value as "amount"
     mapping(address => mapping (address => uint256)) private _allowances;
     
     //amount of total tokens in exictence
     uint256 public _totalSupply;
     
     //owner's address
     address public owner;
     
     string public name;
     string public symbol;
     uint8 public decimals;
     
     constructor() public {
         name = "0xy";
         symbol = "0x";
         decimals = 0;
         owner = msg.sender;
         
         //total supply
         _totalSupply = 100 * 10 ** uint256(decimals);
         
         //Transfer total supply to owner from contract
         _balances[owner] = _totalSupply;
         
         //emit an event on successful Transfer of totalSupply to owner
         emit Transfer(address(this), owner, _totalSupply);
     }
     
     function totalSupply() public override view returns(uint256) {
         return _totalSupply;
     }
     function balanceOf(address account) public override view returns(uint256){
         return _balances[account];
     }
     function transfer(address recipent, uint256 amount) external virtual override returns(bool){
         address sender = msg.sender;
         require(sender != address(0), "LDC: transfer from Zero address");
         require(recipent != address(0), "LDC: transfer to Zero address");
         require(_balances[sender] > amount, "LDC: transfer amount exceeds balance");
         
         //decrease tokens from sender account
         _balances[sender] = _balances[sender].sub(amount);
         
         //increase tokens to recipent account
         _balances[recipent] = _balances[recipent].add(amount);
         
         emit Transfer(sender, recipent, amount);
         return true;
     }
     function allowance(address tokenOwner, address spender) external virtual override view returns(uint256){
         return _allowances[tokenOwner][spender];
     }
     function approve(address spender, uint256 amount) external virtual override returns(bool){
         address tokenOwner = msg.sender;
         require(tokenOwner != address(0), "LDC: approve from the Zero address");
         require(spender != address(0), "LDC: approve to Zero address");
         
         _allowances[tokenOwner][spender] = amount;
         
         emit Approval(tokenOwner, spender, amount);
         return true;
     }
     function transferFrom(address tokenOwner, address recipent, uint256 amount) external virtual override returns(bool){
         address spender = msg.sender;
         uint256 _allowance = _allowances[tokenOwner][spender];
         require(_allowance > amount, "LDC: Transfer amount exceeds allownce");
         
         _allowance = _allowance.sub(amount);
         
         _balances[tokenOwner] = _balances[tokenOwner].sub(amount);
         
         _balances[recipent] = _balances[recipent].add(amount);
         
         emit Transfer(tokenOwner, recipent, amount);
         
         _allowances[tokenOwner][spender] = _allowance;
         
         emit Approval(tokenOwner, spender, amount);
        
        return true;
     }
     function increaseApproval (address _spender, uint _addedValue) 
       public returns (bool success) {
       _allowances[msg.sender][_spender] = _allowances[msg.sender][_spender].add(_addedValue);
       Approval(msg.sender, _spender, _allowances[msg.sender][_spender]);
       return true;
    }
     function decreaseApproval (address _spender, uint _subtractedValue) 
       public returns (bool success) {
       uint oldValue = _allowances[msg.sender][_spender];
       if (_subtractedValue > oldValue) {
       _allowances[msg.sender][_spender] = 0;
        } else {
         _allowances[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
        Approval(msg.sender, _spender, _allowances[msg.sender][_spender]);
         return true;
    }
    
     modifier onlyOwner{
         require(msg.sender == owner);
         _;
     }
     
     function _mint(address account, uint256 _amount, uint256 EnterCapValue) public onlyOwner {
         require(account != address(0), "ERC20: mint to the zero address"); 
         
        _totalSupply = _totalSupply.add(_amount);
        
        require(_totalSupply <= EnterCapValue, "ERROR! Amount Exceeds Limits"); // this require will check the minting amount plus the 
        // total supply if it increases the limits, transaction will revert
        
        _balances[account] = _balances[account].add(_amount);
        emit Transfer(address(0), account, _amount);
    }
 }
