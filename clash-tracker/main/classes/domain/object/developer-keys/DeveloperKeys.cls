public with sharing class DeveloperKeys extends fflib_Objects implements IDeveloperKeys {
    public static IDeveloperKeys newInstance(ClashDeveloperSession session) {
        return (IDeveloperKeys) Application.DTODomain.newInstance(new List<ClashDeveloperSession> { session }, Application.DeveloperKeys_Type);
    }

    public DeveloperKeys(List<ClashDeveloperSession> objects) {
		super(objects);
	}

    public class ClashDeveloperSession {
        public Status status;
        public Integer sessionExpiresInSeconds;
        public List<Key> keys;
    }

    public class Key {
        public String id;
        public String developerId;
        public String tier;
        public String name;
        public String description;
        public List<String> scopes;
        public List<String> cidrRanges;
        public String key;
    }

    public class KeyRequest {
        public String name;
        public String description;
        public List<String> scopes;
        public List<String> cidrRanges;
    }

    public class Status {
        public Integer code;
        public String message;
    }

	public class Constructor implements fflib_IDomainConstructor {
        public fflib_Objects construct(List<Object> objects) {
            return new DeveloperKeys((List<ClashDeveloperSession>) objects);
        }
    }
}