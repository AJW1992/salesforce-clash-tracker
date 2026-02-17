public class Application {
	// Configure and create the UnitOfWorkFactory for this Application
	public static final fflib_Application.UnitOfWorkFactory UnitOfWork = new fflib_Application.UnitOfWorkFactory(
		new List<Schema.SObjectType> {
			Clan__c.SObjectType,
			Player__c.SObjectType,
			Clan_War__c.SObjectType,
			Clan_War_Performance__c.SObjectType
        }
    );
	
	// Configure and create the ClashTrackerUnitOfWorkFactory for this Application
	public static final ClashTrackerUnitOfWorkFactory ClashTrackerUnitOfWork = new ClashTrackerUnitOfWorkFactory(
		new List<Schema.SObjectType> {
			Clan__c.SObjectType,
			Player__c.SObjectType,
			Clan_War__c.SObjectType,
			Clan_War_Performance__c.SObjectType
        }
    );

	// Configure and create the ServiceFactory for this Application
	public static final fflib_Application.ServiceFactory Service = new fflib_Application.ServiceFactory( 
		new Map<Type, Type> {
			IClansService.class => ClansServiceImpl.class,
			IClanWarsService.class => ClanWarsServiceImpl.class,
			IClashDeveloperKeyService.class => ClashDeveloperKeyServiceImpl.class,
			IClashDeveloperLoginService.class => ClashDeveloperLoginServiceImpl.class,
			ICredentialsService.class => CredentialsServiceImpl.class,
			ICurrentIpAddressService.class => CurrentIpAddressServiceImpl.class,
			IPlayersService.class => PlayersServiceImpl.class
        }
    );

	// Configure and create the SelectorFactory for this Application
	public static final fflib_Application.SelectorFactory Selector = new fflib_Application.SelectorFactory(
		new Map<Schema.SObjectType, Type> {
			Clan__c.SObjectType => ClansSelector.class
        }
    );

	/*
	 * NOTE:
	 * 		The difference between SObject domains and Object domains is contextual
	 * 		In this application, Object domains are used to house logic related to data retrieved and mastered by an external API
	 * 		Domains extending fflib_SObjects are meant to work with SObject records
	 * 		Domains extending fflib_Objects do NOT need to work explicitly with SObject records
	 */
	// Configure and create the DomainFactory for this Application (SObjects)
	public static final fflib_Application.DomainFactory Domain = new fflib_Application.DomainFactory(
		Application.Selector,
		new Map<Schema.SObjectType, Type> {
			Clan__c.SObjectType => Clans.Constructor.class,
			Clan_War__c.SObjectType => ClanWars.Constructor.class,
			Clan_War_Performance__c.SObjectType => ClanWarPerformances.Constructor.class,
			Player__c.SObjectType => Players.Constructor.class
        }
    );
	/*
	 * NOTE:
	 * 		final versions of Object keys must be created to ensure matches
	 * 		newInstance(List<Object>, Object):fflib_IDomain
	 * 		this method and its corresponding DomainFactory should use Type as an argument and map key, respectively
	 * 		refactoring of framework code is needed to support
	 */
	public static final Type DeveloperKeys_Type = DeveloperKeys.class;
	/*
	 * NOTE:
	 * 		when using generic Object domains selector factory passed
	 * 		should be extended to support a default query by external id
	 * 		i.e., selectSObjectsByExternalId()
	 */ 
	// Configure and create the DomainFactory for this Application (Objects)
	public static final fflib_Application.DomainFactory DTODomain = new fflib_Application.DomainFactory(
		Application.Selector,
		new Map<Object, Type> {
			DeveloperKeys_Type => DeveloperKeys.Constructor.class
        }
    );
}