package model;

public class ConsultationReport {

    private int appointmentId;
    private String consultInHospital;
    private String medicines;
    private String suggestions;

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public String getConsultInHospital() { return consultInHospital; }
    public void setConsultInHospital(String consultInHospital) {
        this.consultInHospital = consultInHospital;
    }

    public String getMedicines() { return medicines; }
    public void setMedicines(String medicines) {
        this.medicines = medicines;
    }

    public String getSuggestions() { return suggestions; }
    public void setSuggestions(String suggestions) {
        this.suggestions = suggestions;
    }
}
