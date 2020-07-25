pragma solidity 0.4.24;

import "https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.4/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.4/vendor/Ownable.sol";

contract GoogleAuthenticatorPINCheck is ChainlinkClient, Ownable {
  uint256 constant private ORACLE_PAYMENT = 1 * LINK;
  string  constant private JOBID = "f55d1c33b89a45698b54a5727c315096";
  address constant private ORACLE_ADDRESS = 0x149Ce3cd81b1d899df267913a6C6CFBfCe7412BF;
  
  bool public currentPermission;
  
  event RequestGAPINCheckFulfilled(
    bytes32 indexed requestId,
    bool indexed allowed
  );

  constructor() public Ownable() {
    setPublicChainlinkToken();
    currentPermission = false;
  }

  function requestGAPINCheck(string _customerId, string _pin)
    public
    onlyOwner
  {
    Chainlink.Request memory req = buildChainlinkRequest(stringToBytes32(JOBID), this, this.fulfillGAPINCheck.selector);
    
    string memory url = string(genGAPINCheckUrl(_customerId, _pin));
    
    req.add("get", url);
    req.add("path","result");
    req.addInt("times", 100);
    sendChainlinkRequestTo(ORACLE_ADDRESS, req, ORACLE_PAYMENT);
  }


  function fulfillGAPINCheck(bytes32 _requestId, bool _allowed)
    public
    recordChainlinkFulfillment(_requestId)
  {
    currentPermission = _allowed;
    emit RequestGAPINCheckFulfilled(_requestId, currentPermission);
    if (currentPermission) {
        //*********************************************************************
        // TO DO THE SPECIAL ACTION
        //*********************************************************************
        //currentPermission = false;
    }
  }

  function getChainlinkToken() public view returns (address) {
    return chainlinkTokenAddress();
  }

  function withdrawLink() public onlyOwner {
    LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
    require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
  }

  function cancelRequest(
    bytes32 _requestId,
    uint256 _payment,
    bytes4 _callbackFunctionId,
    uint256 _expiration
  )
    public
    onlyOwner
  {
    cancelChainlinkRequest(_requestId, _payment, _callbackFunctionId, _expiration);
  }

  function genGAPINCheckUrl(string _customerId, string _pin) private pure returns (bytes) {
    string memory url_1 = "http://164.90.156.225/?pin=";
    string memory url_3 = "&customerid=";
    
    bytes memory burl_1 = bytes(url_1);
    bytes memory burl_2 = bytes(_pin);
    bytes memory burl_3 = bytes(url_3);
    bytes memory burl_4 = bytes(_customerId);

    bytes memory burl = bytes(new string(burl_1.length + burl_2.length + burl_3.length + burl_4.length));
 
    uint k = 0;
    uint i = 0;
    for (i = 0; i < burl_1.length; i++) burl[k++] = burl_1[i];
    for (i = 0; i < burl_2.length; i++) burl[k++] = burl_2[i];
    for (i = 0; i < burl_3.length; i++) burl[k++] = burl_3[i];
    for (i = 0; i < burl_4.length; i++) burl[k++] = burl_4[i];

    return (burl);
  }
  
  function stringToBytes32(string memory source) private pure returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
      return 0x0;
    }

    assembly { // solhint-disable-line no-inline-assembly
      result := mload(add(source, 32))
    }
  }

}
