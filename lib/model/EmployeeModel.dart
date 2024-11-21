
class EmployeeModel{
  String id;
  String employeeName;
  String employeeSalary;
  String employeeAge;
  String profileImage;

  static EmployeeModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    EmployeeModel dataBean = EmployeeModel();
    dataBean.id = map['id'];
    dataBean.employeeName = map['employee_name'];
    dataBean.employeeSalary = map['employee_salary'];
    dataBean.employeeAge = map['employee_age'];
    dataBean.profileImage = map['profile_image'];
    return dataBean;
  }

  Map toJson() => {
    "id": id,
    "employee_name": employeeName,
    "employee_salary": employeeSalary,
    "employee_age": employeeAge,
    "profile_image": profileImage,
  };


}