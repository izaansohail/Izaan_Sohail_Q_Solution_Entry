// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./QTKN.sol";
import "./StudentContract.sol";

contract SchoolSmartContract{
    address public owner;
    address public courseAddress;
    uint256 public minimumSchoolShare;
    string public courseName;
    string public courseCode;
    uint256 public teacherShare;
    uint256 public schoolShare;
    uint256 public basePrice;
    uint256 public totalPrice;
    string public instructor;
    QTKN private currentToken;
    uint256 public tokenID;
    uint256 public accountBalance;
    StudentContract private currentCourse;
    bool isPass = false;

    struct course{
        address courseAddress;
        string courseName;
        string courseCode;
        uint256 teacherShare;
        uint256 schoolShare;
        uint256 basePrice;
        string instructor;
        uint256 totalPrice;
        bool isPass;
    }
    
    event PrintIndex(uint256, course);
    event Print(uint256, uint256);
    course[] public courseList;
    mapping(address=>uint256) courseDict;
    constructor(uint256 _minimumSchoolShare) {
        owner = msg.sender;
        minimumSchoolShare = _minimumSchoolShare; 
    }

    function RegisterCourse(string memory _courseName, string memory _courseCode) public{
        currentCourse = new StudentContract(_courseName, courseCode);
    }

    function addCourse(
        string memory _courseName, 
        string memory _courseCode,
        uint256 _teacherShare, 
        uint256 _schoolShare, 
        address _courseAddress,  
        uint256 _basePrice, 
        string memory _instructor
        ) 
        public 
        returns(bool) 
        {    
            if(courseDict[courseAddress] == 0){
                require(_schoolShare >= minimumSchoolShare, "School Share lower then the lower limit");
                courseAddress = _courseAddress;
                courseName = _courseName;
                courseCode = _courseCode;
                teacherShare = _teacherShare;
                schoolShare = _schoolShare;
                basePrice = _basePrice;
                instructor = _instructor;
                isPass = false;
                totalPrice = 0;
                courseList.push(course(courseAddress ,courseName, courseCode, teacherShare, 
                                        schoolShare, basePrice, instructor, totalPrice,isPass));
                uint256 index = courseList.length;
                courseDict[courseAddress] = index;
                return true;
            }else{
                return false;
            }
        }

    function changeSchoolShare(uint256 _minimumSchoolShare) public {
        require(msg.sender == owner, "Owner Privelages not granted");
        minimumSchoolShare = _minimumSchoolShare;
    }

    function calculateCoursePrice(address _courseAddress) public returns(uint256){
        for(uint i = 0; i < courseList.length;i++)
        {
            if(_courseAddress == courseList[i].courseAddress)
            {
                courseList[i].totalPrice =  courseList[i].basePrice + (courseList[i].basePrice * 3/100) + (courseList[i].basePrice * courseList[i].schoolShare/100);
                courseList[i].totalPrice = courseList[i].totalPrice / 100;
                return courseList[i].totalPrice;
            }
        }
    }

    function returnCourseList() public view returns(course[] memory){
        return courseList;
    }

    function buyCurrency(uint256 _amount) public payable{
        currentToken = new QTKN(msg.sender);
        accountBalance = currentToken.buy(_amount,msg.sender);
        // accountBalance = 50000;
    }

    function courseClear(address _courseAddress) public {
        for(uint i = 0; i < courseList.length;i++)
        {
            if(_courseAddress == courseList[i].courseAddress)
            {
                courseList[i].isPass = true; 
            }
        }
    }

    function mintCourseNFT(address _courseAddress, string memory tokenURI ) public payable {
        for(uint i = 0; i < courseList.length;i++)
        {
            if(_courseAddress == courseList[i].courseAddress)
            {
                emit Print(accountBalance, courseList[i].totalPrice);
                require(accountBalance >= courseList[i].totalPrice, "Not enough Balance");
                require(courseList[i].isPass == true, "Course Not Cleared Yet");
                currentCourse.createToken(tokenURI);
            }
        }
    }
    
}
