public interface IPlayers extends fflib_ISObjects {
    void insertClanMembers(fflib_ISObjectUnitOfWork uow);
    void upsertPlayers(fflib_ISObjectUnitOfWork uow, IClashTrackerWork work);
}