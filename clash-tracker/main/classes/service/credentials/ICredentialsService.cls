public interface ICredentialsService {
    void createClashApiCredential();
    void patchClashApiCredential();
    void createClashDeveloperCredential(String email, String password);
    void patchClashDeveloperCredential(String email, String password);
}