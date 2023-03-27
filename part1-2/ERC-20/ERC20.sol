// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    event Transfer(address from, address to, uint amount);

    constructor(string memory _name_, string memory _symbol_, uint8 private _decimals_){
        _name = _name_;
        _symbol = _symbol_;
        _decimals = _decimals_;
        _totalSupply = 100000 * (10 ** 18);
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(_balances[from] > amount, "not available amount");
        unchecked {
            _balances[from] -= amount;
            _balances[to] += amount;
        }
        emit Transfer(from, to, amount);
        return true;
    }

    function _mint(address account, uint256 amount) internal virtual {
        unchecked {
            _totalSupply += amount;
            _balances[account] += amount;
        }
    }

    function _burn(address account, uint256 amount) internal virtual {
        unchecked {
             _totalSupply -= amount;
            _balances[account] -= amount;
        }
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        _allowances[owner][spender] = amount;
    }

}