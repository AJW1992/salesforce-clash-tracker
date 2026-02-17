public interface IClashApiService {
    void execute();
    void handleServiceResponse();
    void setRequest(Map<String, String> argumentsByParameter);
}