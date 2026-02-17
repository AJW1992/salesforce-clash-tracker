public interface IPlayersService extends IClashApiService {
    void upsertPlayers(List<String> playerTags);
}