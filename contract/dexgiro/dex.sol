contract dex {
    IERC20 private _token;
    address private _admin;
    mapping(address => bool) private addressToPermission;

    event Withdraw(address indexed address_, uint256 amount_);
    event ClaimWithDraw(
        address indexed address_,
        uint256 amount_,
        uint256 idGame
    );
    event Deposit(address indexed address_, uint256 amount_, uint256 idGame);

    constructor(IERC20 token_) {
        _token = token_;
        _admin = msg.sender;
        addressToPermission[msg.sender] = true;
    }

    function setPermission(address account) external isAdmin {
        require(account != address(0), "Owner is required address not zero");
        addressToPermission[account] = true;
    }

    function delPermission(address account) external isAdmin {
        require(account != address(0), "Owner is required address not zero");
        delete addressToPermission[account];
    }

    function isSetPermission(address account) external view returns (bool) {
        require(account != address(0), "Owner is required address not zero");
        return addressToPermission[account];
    }

    function withdraw(uint256 amount_) public isAdmin {
        require(amount_ > 0, "Amount is  grater than 0");
        uint256 totalAmount = _token.balanceOf(address(this));
        require(
            amount_ <= totalAmount,
            "Amount is greater than total Amount of SM"
        );
        _token.transfer(msg.sender, amount_);
        emit Withdraw(msg.sender, amount_);
    }

    function claimWithdraw(
        address spender_,
        uint256 amount_,
        uint256 idGame
    ) public isOwner {
        require(amount_ > 0, "Amount is  grater than 0");
        uint256 totalAmount = _token.balanceOf(address(this));
        require(
            amount_ <= totalAmount,
            "Amount must be less than total Amount of SM"
        );
        _token.transfer(spender_, amount_);
        emit ClaimWithDraw(spender_, amount_, idGame);
    }

    function deposit(uint256 amount_, uint256 idGame) public {
        require(amount_ > 0, "Amount is  greater than 0");
        uint256 userAmount = _token.balanceOf(msg.sender);
        require(amount_ <= userAmount, "Your Amount is not enought");
        _token.transferFrom(msg.sender, address(this), amount_);
        emit Deposit(msg.sender, amount_, idGame);
    }

    modifier isOwner() {
        require(
            addressToPermission[msg.sender] || _admin == msg.sender,
            "You're not Owner"
        );
        _;
    }

    modifier isAdmin() {
        require(_admin == msg.sender, "You're not admin");
        _;
    }
}