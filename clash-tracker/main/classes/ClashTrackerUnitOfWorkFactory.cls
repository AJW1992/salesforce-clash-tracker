/**
 * NOTE: need to extend the base factory to allow the central access point through the factory that
 *       supports awareness of an instance of the fflib_ISObjectUnitOfWork that has already been instantiated
 * 
 */
public with sharing class ClashTrackerUnitOfWorkFactory extends fflib_Application.UnitOfWorkFactory implements IClashTrackerUnitOfWorkFactory {
    private static fflib_ISObjectUnitOfWork Instance;

    public ClashTrackerUnitOfWorkFactory(List<Schema.SObjectType> sObjectTypes) {
        super(sObjectTypes);
    }

    public fflib_ISObjectUnitOfWork getInstance() {
        if (Instance == null) {
            Instance = this.newInstance();
        }

        return Instance;
    }
}