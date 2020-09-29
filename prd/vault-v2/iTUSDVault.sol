/**
 *Submitted for verification at Etherscan.io on 2020-08-13
*/

pragma solidity ^0.5.16;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }
}

contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }
    function name() public view returns (string memory) {
        return _name;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface Controller {
    function withdraw(address, uint) external;
    function balanceOf(address) external view returns (uint);
    function earn(address, uint) external;
    function rewards() external view returns (address);
    function vaults(address) external view returns (address);
    function strategies(address) external view returns (address);
}

interface MyVault {
    function harveYFXI(address) external view returns (uint);
}

contract iVault is ERC20, ERC20Detailed {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
    
    IERC20 public token;
    address public tokenAddress;

    uint public min = 9500;
    uint public constant max = 10000;
    uint public earnLowerlimit; //池内空余资金到这个值就自动earn
    
    address public governance;
    address public controller;
    
    constructor (address _token,uint _earnLowerlimit) public ERC20Detailed(
        string(abi.encodePacked("yfii ", ERC20Detailed(_token).name())),
        string(abi.encodePacked("i", ERC20Detailed(_token).symbol())),
        ERC20Detailed(_token).decimals()
    ) {
        token = IERC20(_token);
        tokenAddress = _token;
        governance = tx.origin;
        //TODO 修改controller地址
        controller = 0xEa0c29FF6201355A475ff081Ea69d1C9C695Ec6c;
        earnLowerlimit = _earnLowerlimit;
    }
    
    //TODO 设置 yfxi 代币地址
    address constant public yfxi = address(0xcb00892dDedeF6e5904c9984a5702a1cD0B9003B);
    address constant public ycrv = address(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
    struct IYfxi {
        uint256 yfxiShares; // 对应的yfxi份额
    }
    mapping(address => IYfxi) public _iyfxi;
    struct IYfxiGlobal {
        uint256 totalYfxiShares; // 总质押份额
    }
    mapping(uint256 => IYfxiGlobal) public _global;

    //在mint之前调用
    function setDepositForYFXI(uint256 _tokenShares) internal {
        //获取Vault在yfxi的余额, 触发harvest后策略会将收益兑换成yfxi转给vault
        uint256 _yfxi_bal = balanceOfYFXI();
        //将yfxi余额加上iToken总发行量作为总yfxi余额, 因为在mint之前调用 totalSupply 不包括 tokenShares
        uint256 _total_yfxi_bal = _yfxi_bal.add(totalSupply());
        //获取yfxi的总份额
        uint256 _total_yfxi_share = _global[0].totalYfxiShares;
        //默认本次质押换算成的yfxi份额 = 质押token份额
        uint256 _shares = _tokenShares;
        //非首次质押需要做yfxi份额换算
        if(_total_yfxi_share > 0){
            //换算成yfxi份额, 由于都是整数计算, 会有尾差
            _shares = _tokenShares.mul(_total_yfxi_share).div(_total_yfxi_bal);
        }
        //记录本次质押用户的yfxi份额
        _iyfxi[msg.sender].yfxiShares = _iyfxi[msg.sender].yfxiShares.add(_shares);
        //记录yfxi总份额
        _global[0].totalYfxiShares = _global[0].totalYfxiShares.add(_shares);
    }

    //因为TUSD将金额放入了 ycrv 的 vault 中需要做转换
    function balanceOfYFXI() internal view returns (uint256) {
        address _vault = Controller(controller).vaults(ycrv);
        address _strategy = Controller(controller).strategies(tokenAddress);
        uint256 _bal = MyVault(_vault).harveYFXI(_strategy);
        return _bal.add(IERC20(yfxi).balanceOf(address(this)));
    }

    //有多少yfxi未提取
    function harveYFXI(address account) public view returns (uint){
        //用户持有yfxi份额
        uint256 _user_yfxi_shares = _iyfxi[account].yfxiShares;
        //vault 持有的 yfxi 数量
        uint256 _yfxi_bal = balanceOfYFXI();
        //未提取的yfxi数量
        uint256 _yfxi = 0;
        if(_global[0].totalYfxiShares > 0){
            _yfxi = _yfxi_bal.add(totalSupply()).mul(_user_yfxi_shares).div(_global[0].totalYfxiShares);
            uint256 _bal = balanceOf(account);
            if(_yfxi >= _bal){
                //防止负数溢出
                _yfxi = _yfxi.sub(balanceOf(account));
            }else{
                _yfxi = 0;
            }
        }
        return _yfxi;
    }

    //在burn之前调用
    function withdrawForYFXI(uint256 _tokenShares) internal {
        //用户获取的yfxi, 提取时 会先触发 ycrv 的提取, 理论上提取的yfxi即本次用户提取的金额
        uint256 _withdraw_yfxi = IERC20(yfxi).balanceOf(address(this));
        uint256 _withdraw_yfxi_shares = _iyfxi[msg.sender].yfxiShares;
        uint256 _user_total = balanceOf(msg.sender);
        //只提取部分
        if(_tokenShares < _user_total){
            _withdraw_yfxi_shares = _withdraw_yfxi_shares.mul(_tokenShares).div(_user_total);
        }
        //扣减用户持有的份额
        _iyfxi[msg.sender].yfxiShares = _iyfxi[msg.sender].yfxiShares.sub(_withdraw_yfxi_shares);
        _global[0].totalYfxiShares = _global[0].totalYfxiShares.sub(_withdraw_yfxi_shares);
        //提取yfxi给用户
        if(_withdraw_yfxi > 0){
            IERC20(yfxi).transfer(msg.sender,_withdraw_yfxi);
        }
        if(_tokenShares == totalSupply()){
            //全部提取完
            uint256 _yfxi_bal = balanceOfYFXI();
            if(_yfxi_bal > 0){
                //全部提取完后尾差处理
                IERC20(yfxi).transfer(Controller(controller).rewards(),_yfxi_bal);
            }
        }
    }

    function balance() public view returns (uint) {
        return token.balanceOf(address(this))
                .add(Controller(controller).balanceOf(address(token)));
    }
    
    function setMin(uint _min) external {
        require(msg.sender == governance, "!governance");
        min = _min;
    }
    
    function setGovernance(address _governance) public {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }
    
    function setController(address _controller) public {
        require(msg.sender == governance, "!governance");
        controller = _controller;
    }
    function setEarnLowerlimit(uint256 _earnLowerlimit) public{
      require(msg.sender == governance, "!governance");
      earnLowerlimit = _earnLowerlimit;
  }
    
    // Custom logic in here for how much the vault allows to be borrowed
    // Sets minimum required on-hand to keep small withdrawals cheap
    function available() public view returns (uint) {
        return token.balanceOf(address(this)).mul(min).div(max);
    }
    
    function earn() public {
        uint _bal = available();
        token.safeTransfer(controller, _bal);
        Controller(controller).earn(address(token), _bal);
    }
    
    function depositAll() external {
        deposit(token.balanceOf(msg.sender));
    }
    
    function deposit(uint _amount) public {
        uint _pool = balance();
        uint _before = token.balanceOf(address(this));
        token.safeTransferFrom(msg.sender, address(this), _amount);
        uint _after = token.balanceOf(address(this));
        _amount = _after.sub(_before); // Additional check for deflationary tokens
        uint shares = 0;
        if (totalSupply() == 0) {
            shares = _amount;
        } else {
            shares = (_amount.mul(totalSupply())).div(_pool);
        }
        //记录yfxi份额
        setDepositForYFXI(shares);
        _mint(msg.sender, shares);
        if (token.balanceOf(address(this))>earnLowerlimit){
          earn();
        }
    }
    
    function withdrawAll() external {
        withdraw(balanceOf(msg.sender));
    }
    
    
    
    // No rebalance implementation for lower fees and faster swaps
    function withdraw(uint _shares) public {
        uint r = (balance().mul(_shares)).div(totalSupply());

        // Check balance
        uint b = token.balanceOf(address(this));
        if (b < r) {
            uint _withdraw = r.sub(b);
            Controller(controller).withdraw(address(token), _withdraw);
            uint _after = token.balanceOf(address(this));
            uint _diff = _after.sub(b);
            if (_diff < _withdraw) {
                r = b.add(_diff);
            }
        }

        //提取对应的yfxi
        withdrawForYFXI(_shares);
        _burn(msg.sender, _shares);

        token.safeTransfer(msg.sender, r);
    }

    function getPricePerFullShare() public view returns (uint) {
        if(totalSupply() > 0){
            return balance().mul(1e18).div(totalSupply());
        }else{
            return 0;
        }
    }
}