// DISHANT RAJPUT

import UIKit



// edit with image
struct EditUserWithImage: Encodable {
    let action: String
    let userId: String
    let fullName: String
    let contactNumber: String
    let address: String
}

// edit without image
struct EditUserWithoutImage: Encodable {
    let action: String
    let userId: String
    let fullName: String
    let contactNumber: String
    let address: String
}

// change password
struct ChangePasswordW: Encodable {
    let action: String
    let userId: String
    let oldPassword: String
    let newPassword: String
}

struct Order_Details_WB: Encodable {
    let action: String
    let orderId: String
    let supplierId: String
}

// MARK:- HOSPITAL PARAMS -
struct HospitalRegistrationParam: Encodable {
    let action: String
    let username: String
    let fullName: String
    let email: String
    let password: String
    let contactNumber: String
    let address: String
    let countryId: String
    let device: String
    let role: String
    let specialty: String
    let department: String
    let latitude: String
    let longitude: String
    let description: String
}

// MARK:- HOSPITAL PARAMS -
struct HospitalLabRegistrationParam: Encodable {
    let action: String
    let addedBy: String
    let username: String
    let fullName: String
    let email: String
    let password: String
    let contactNumber: String
    let address: String
    let countryId: String
    let device: String
    let role: String
    let specialty: String
    let department: String
    let latitude: String
    let longitude: String
    let description: String
    let open_time: String
    let close_time: String
}

// MARK:- HOSPITAL PARAMS -
struct Edit_Labs_Details: Encodable {
    let action: String
    let userId: String
    let username: String
    let fullName: String
    let email: String
    let password: String
    let contactNumber: String
    let address: String
    let countryId: String
    let device: String
    let role: String
    let specialty: String
    let department: String
    let latitude: String
    let longitude: String
    let description: String
    let open_time: String
    let close_time: String
}


/*
 [action] => login
     [login_id] => lab5@mailinator.com
     [password] => 123456
     [device] => Android
     [deviceToken] => etYt3_fBRH6phQpnuEMEB8:APA91bHlEp1sxX2UX-21PXTE56xISfOdF1orb3iNJLmQL1DKV5FKG6st_5_2TwkOuL32Mg6rVU_uQaXFfDlCDf994wZ5-1_Z5UlGopopa6OLOIjCDhiIyEp_JkeqjDDju13kf395wmNt
     [latitude] => 28.4939516
     [longitude] => 77.2312427
 */

struct LoginParam: Encodable {
    let action: String
    let login_id: String
    let password: String
    let device: String
    let deviceToken: String
    let latitude: String
    let longitude: String
}

struct DoctorsList: Encodable {
    let action: String
    let role: String
    let addedBy: String
    let keyword: String
}

struct AddDoctors: Encodable {
    let action: String
    let addedBy: String
    let username: String
    let fullName: String
    let email: String
    let contactNumber: String
    let password: String
    let address: String
    let practiceDate: String
    let department: String
    let specialty: String
    let device: String
    let role: String
    let latitude: String
    let longitude: String
    let countryId:String
     
}

struct Register_Pharmacy: Encodable {
    let action: String
    let addedBy: String
    let username: String
    let fullName: String
    let email: String
    let contactNumber: String
    let password: String
    let address: String
    let device: String
    let role: String
    let latitude: String
    let longitude: String
    let countryId:String
    let open_time:String
    let close_time:String
    let description:String
}

struct Edit_Pharmacy: Encodable {
    let action: String
    let userId: String
    let username: String
    let fullName: String
    let email: String
    let contactNumber: String
    let password: String
    let address: String
    let device: String
    let role: String
    let latitude: String
    let longitude: String
    let countryId:String
    let open_time:String
    let close_time:String
    let description:String
}

struct Add_Supplier: Encodable {
    let action: String
    let addedBy: String
    let username: String
    let fullName: String
    let email: String
    let contactNumber: String
    let password: String
    let address: String
    let practiceDate: String
    let department: String
    let specialty: String
    let device: String
    let role: String
    let latitude: String
    let longitude: String
    let countryId:String
    let description:String
}

struct EditDoctors: Encodable {
    let action: String
    let addedBy:String
    let userId: String
    let username: String
    let fullName: String
    let email: String
    let contactNumber: String
    let password: String
    let address: String
    let practiceDate: String
    let department: String
    let specialty: String
    let device: String
    let role: String
     let latitude: String
     let longitude: String
    let countryId: String
}

struct DeleteDoctors: Encodable {
    let action: String
    let userId: String
}

struct Delete_All_Cart: Encodable {
    let action: String
    let userId: String
}


struct AddPatient: Encodable {
    let action: String
    let addedBy: String
    let registeredDt: String
    let medicalCardID: String
    let fullName: String
    let middleName: String
    let lastName: String
    let dob: String
    let username: String
    let email: String
    let contactNumber: String
    let password: String
    let city: String
    let height: String
    let eyeColor: String
    let securityNumber:String
    let zipCode: String
    let countryId: String
    let device: String
    let role: String
    let latitude: String
    let longitude: String
    let gender: String
    let fee_Paid_for_M_card:String
    let address:String
}

struct EditPatient: Encodable {
    let action: String
    let addedBy: String
    let userId: String
    let registeredDt: String
    let medicalCardID: String
    let fullName: String
    let middleName: String
    let lastName: String
    let dob: String
    let username: String
    let email: String
    let contactNumber: String
    let password: String
    let city: String
    let height: String
    let eyeColor: String
    let securityNumber:String
    let zipCode: String
    let countryId: String
    let device: String
    let role: String
    let latitude: String
    let longitude: String
    let gender: String
    let fee_Paid_for_M_card:String
    let address:String
}

struct CreatePatientMedicalId: Encodable {
    let action: String
}

struct countryListWeb: Encodable {
    
    //parameter
    let action: String
}

struct hospitalClininicListWeb: Encodable {
    
    //parameter
    let action:String
    let role: String
    let addedBy: String
}

/*
 [action] => addmedicalhistory
     [userId] => 198
     [hospitalId] => 182
     [disease] => eye problem
     [gender] => male
     [medicine] => No Medication
     [using_alcohol] => No Allergies
     [allergies] => No Drug
     [use_medicine] => No
     [have_allergies] => No
     [alcohol] => No
 */
struct AddDPatientMedicalHistoryWithoutImage: Encodable {
    let action: String
    let userId: String
    let hospitalId: String
    let disease: String
    let gender: String
    let medicine: String
    let allergies: String
    let using_alcohol: String
    let use_medicine: String
    let have_allergies: String
    let alcohol: String
}

struct editPatientMedicalHistoryWithoutImage: Encodable {
    let action: String
    let userId: String
    let medicalHistoryId: String
    let hospitalId: String
    let disease: String
    let gender: String
    let medicine: String
    let allergies: String
    let using_alcohol: String
    let use_medicine: String
    let have_allergies: String
    let alcohol: String
}

struct ListMedicineList: Encodable {
    let action: String
    // let supplierId: String
}
 
struct AddToCart: Encodable {
    let action: String
    let userId: String
    let medicine_id: String
    let quantity: String
    let price: String
    let supplierId:String
    let updateCart:String
}

struct CartList: Encodable {
    let action: String
    let userId: String
}

struct DeleteCart: Encodable {
    let action: String
    let userId: String
    let medicineId: String
}

struct SaveOrderAfterPayment: Encodable {
    let action: String
    let hospitalId: String
    let supplierId: String
    let quantity: String
    let medicine_id: String
    let address: String
    let contact_person: String
    let mobile: String
    let special_note: String
    let total: String
    let delivery_date:String
}

// action : orderhistory( )
// userId :

struct OrderHistory: Encodable {
    let action: String
    let userId: String
}

// PATIENT
struct Patient_Appoitment_List: Encodable {
    let action: String
    let userId: String
    let type: String
    let Adate: String
}

/*
 [action] => addappointment
     [userId] => 161
     [hospitalId] => 163
     [doctorId] => 170
     [Adate] => 2021-09-20
     [ATime] => Select Date
 */

struct Patient_Book_Appoitment: Encodable {
    let action: String
    let userId: String
    let hospitalId: String
    let doctorId: String
    let Adate: String
    let ATime: String
}

struct MedicalHistory: Encodable {
    let action: String
    let userId: String
    let doctorId: String
    let hospitalId: String
}

struct medical_history_for_pharmacy: Encodable {
    let action: String
    let userId: String
    let doctorId: String
    let hospitalId: String
    let type: String
}

struct AppointmentDetails: Encodable {
    let action: String
    let appointmentId: String
}

struct AppointmentDetailsImage: Encodable {
    let action: String
    let userId: String
    let appointmentId: String
}

struct PatientEHealthMedicalCard: Encodable {
    let action: String
    let userId: String
}

// all prescription list
struct Patient_List_of_all_Prescription: Encodable {
    let action: String
    let userId: String
    let doctorId: String
    let hospitalId: String
    let appointmentId: String
}

// doctor add note
struct Doctor_Add_Notes: Encodable {
    let action: String
    let userId: String
    let doctorId: String
    let hospitalId: String
    let content: String
    let appointmentId: String
}

// notes list
struct Doctor_All_Notes_List: Encodable {
    let action: String
    let userId: String
    let doctorId: String
    let appointmentId: String
}

// notes edit
struct Doctor_Edit_Note: Encodable {
    let action: String
    let noteId: String
    let content: String
}


// all disease
struct List_Of_All_Disease: Encodable {
    let action: String
    let keyword: String
}

// medicine of that disease
struct Medicine_Of_That_Disease: Encodable {
    let action: String
    let supplierId:String
    let diseaseId: String
}

 
// medicine of that disease
struct Edit_Medicine_Quantity: Encodable {
    let action: String
    let sm_id:String
    let supplierId: String
    let medicineId: String
    let quantity: String
}

struct Mark_As_Delivered: Encodable {
    let action: String
    let orderId:String
    let delivery_status: String
}

struct Add_Medicine_Without_Image: Encodable {
    let action: String
    let supplierId: String
    let name: String
    let price: String
    let quantity: String
    let medicine_id: String
}

struct List_Of_All_Medicines: Encodable {
    let action: String
    let keyword: String
    let pageNo: String
}

struct Add_New_Medicine_Without_Image: Encodable {
    let action: String
    let supplierId: String
    let diseaseId: String
    let name: String
    let price: String
    let quantity: String
    let medicine_id: String
}

struct Edit_Medicine_Without_Image: Encodable {
    let action: String
    let sm_id:String
    let supplierId: String
    let diseaseId: String
    let name: String
    let price: String
    let quantity: String
    let medicine_id: String
}

struct send_panic_notification: Encodable {
    let action: String
    let userId: String
    let latitude: String
    let longitude: String
}

struct logout_my_app: Encodable {
    let action: String
    let userId: String
}

struct show_only_test_list: Encodable {
    let action: String
    let userId: String
}

struct show_only_prescription_list: Encodable {
    let action: String
    let userId: String
    let login_id: String
}

struct lab_request_medical_history_permission: Encodable {
    let action: String
    let login_id: String
    let userId: String
    let hospitalId: String
    let medicalHistoryId: String
}

struct status_change_request_medical_history_from_labs: Encodable {
    let action: String
    let userId: String
    let hospitalId: String
    let medicalHistoryId: String
    let request_reply: String
}

struct status_change_request_prescription_from_pharmacy: Encodable {
    let action: String
    let userId: String
    let hospitalId: String
    let prescriptionId: String
    let request_reply: String
}

struct ask_permission_for_patient_prescription: Encodable {
    let action: String
    let userId: String
    let login_id: String
    let hospitalId: String
    let prescriptionId: String
}

class Parameters: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
