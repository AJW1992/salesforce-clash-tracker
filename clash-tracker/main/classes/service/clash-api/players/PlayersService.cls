public with sharing class PlayersService {
    public static void upsertPlayers(List<String> playerTags) {
        service().upsertPlayers(playerTags);
    }

    private static IPlayersService service() {
        return (IPlayersService) Application.Service.newInstance(IPlayersService.class);
    }
}