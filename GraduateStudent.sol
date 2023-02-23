pragma solidity ^0.5.3;
//pragma experimental ABIEncoderV2;

import "./StandardToken.sol";


// Check degree authenticity delivery by higher education institution
contract GraduateStudent {
    address private owner;
    address private token;

    struct HigherEducationInstitution {
        string name;
        string institutionType;
        string country;
        string institutionAddress;
        string website;
        uint256 agentId;
    }
    struct Student {
        bool exist;
        string name;
        string firstname;
        string birthdate;
        string gender;
        string nationality;
        string civilStatus;
        string studentAddress;
        string email;
        string phone;
        string section;
        string pfeSubject;
        string companyInternshipPfe;
        string internshipSupervisor;
        uint256 internshipStartDate;
        uint256 internshipEndDate;
        string evaluation;
    }
    struct Degree {
        bool exist;
        uint256 ownerId;
        string institutionName;
        uint256 eesId;
        string country;
        string degreeType;
        string speciality;
        string mention;
        uint256 obtainedDate;
    }
    struct Company {
        string name;
        string sector;
        uint256 creationDate;
        string sizeClassification;
        string country;
        string companyAddress;
        string email;
        string phone;
        string website;
    }
    mapping(uint256 => HigherEducationInstitution) public HigherEducationInstitutions;
    mapping(address => uint256) AddressHigherEducationInstitutions;
    mapping(uint256 => Student) Students;
    mapping(uint256 => Company) public Companies;
    mapping(address => uint256) public AddressCompanies;
    mapping(uint256 => Degree) public Degrees;

    function getStudent(uint256 id) public view returns (Student memory) {
        return Students[id];
    }

    uint256 public NbHigherEducationInstitutions;
    uint256 public NbStudents;
    uint256 public NbCompanies;
    uint256 public NbDegrees;

    constructor(address tokenAddress) public {
        token = tokenAddress;
        owner = msg.sender;

        NbHigherEducationInstitutions = 0;
        NbStudents = 0;
        NbCompanies = 0;
        NbDegrees = 0;
    }

    function addHigherEducationInstitution(HigherEducationInstitution memory institution, address a) private {
        NbHigherEducationInstitutions += 1;
        HigherEducationInstitutions[NbHigherEducationInstitutions] = institution;
        AddressHigherEducationInstitutions[a] = NbHigherEducationInstitutions;
    }

    function addCompany(Company memory company, address a) private {
        NbCompanies += 1;
        Companies[NbCompanies] = company;
        AddressCompanies[a] = NbCompanies;
    }

    function addStudent(Student memory student) private {
        student.exist = true;
        NbStudents += 1;
        Students[NbStudents] = student;
    }

    function addDegree(Degree memory degree) private {
        degree.exist = true;
        NbDegrees += 1;
        Degrees[NbDegrees] = degree;
    }

    function addHigherEducationInstitution(string memory name) public {
        HigherEducationInstitution memory institution;
        institution.name = name;
        addHigherEducationInstitution(institution, msg.sender);
    }

    function addCompany(string memory name) public {
        Company memory company;
        company.name = name;
        addCompany(company, msg.sender);
    }

    function addStudent(string memory name, string memory firstname) public {
        uint256 id = AddressHigherEducationInstitutions[msg.sender];
        require(id != 0, "ERROR : NO INSTITUTION");
        Student memory student;
        student.name = name;
        student.firstname = firstname;
        addStudent(student);
    }

    function addDegree(uint256 ownerId) public {
        uint256 id = AddressHigherEducationInstitutions[msg.sender];
        require(id != 0, "ERROR : NO INSTITUTION");
        require(Students[ownerId].exist == true, "ERROR : NO STUDENT");
        Degree memory degree;
        degree.ownerId = ownerId;
        degree.institutionName = HigherEducationInstitutions[id].name;
        addDegree(degree);
    }

    function studentEvaluation(
        uint256 studentId,
        string memory pfeSubject,
        string memory companyInternshipPfe,
        string memory internshipSupervisor,
        uint256 internshipStartDate,
        uint256 internshipEndDate,
        string memory evaluation
    ) public {
        uint256 id = AddressHigherEducationInstitutions[msg.sender];
        require(id != 0, "ERROR : NO INSTITUTION");
        require(Students[studentId].exist == true, "ERROR : NO STUDENT");
        Students[studentId].pfeSubject = pfeSubject;
        Students[studentId].companyInternshipPfe = companyInternshipPfe;
        Students[studentId].internshipSupervisor = internshipSupervisor;
        Students[studentId].internshipStartDate = internshipStartDate;
        Students[studentId].internshipEndDate = internshipEndDate;
        Students[studentId].evaluation = evaluation;
        require(
            Token(token).allowance(owner, address(this)) >= 15,
            "ERROR : TOKEN NOT ALLOWED"
        );
        require(
            Token(token).transferFrom(owner, msg.sender, 15),
            "ERROR : TRANSFER FAIL"
        );
    }

    event checkResult(bool, Degree);

    function checkDegree(uint256 idDegree) public returns (bool, Degree memory) {
        require(
            Token(token).allowance(msg.sender, address(this)) >= 10,
            "ERROR : TOKEN NOT ALLOWED"
        );
        require(
            Token(token).transferFrom(msg.sender, owner, 10),
            "ERROR : TRANSFER FAIL"
        );
        emit checkResult(Degrees[idDegree].exist, Degrees[idDegree]);
        return (Degrees[idDegree].exist, Degrees[idDegree]);
    }
}
