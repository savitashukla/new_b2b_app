import 'package:gmng/model/basemodel/AppBaseResponseModel.dart';

import '../EmployeeModel.dart';

/// status : "success"
/// data : [{"id":"1","employee_name":"Tiger Nixon","employee_salary":"320800","employee_age":"61","profile_image":""},{"id":"2","employee_name":"Garrett Winters","employee_salary":"170750","employee_age":"63","profile_image":""}]

class EmployeeResponseModel extends AppBaseResponseModel{
  List<EmployeeModel> data;

  static EmployeeResponseModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    EmployeeResponseModel employeeModelBean = EmployeeResponseModel();
   // employeeModelBean.status = map['status'];
    employeeModelBean.data = []..addAll(
      (map['data'] as List ?? []).map((o) => EmployeeModel.fromMap(o))
    );
    return employeeModelBean;
  }

  Map toJson() => {
  //  "status": status,
    "data": data,
  };
}

