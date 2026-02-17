// NOTE: could not find a way to make dynamic Apex classes compatible with LightningTypeBundle on deployment
public class VerifyToken {
    public class Request {
        public String tag;
        public String token;
    }

    public class Response {
        public String tag;
        public String token;
        public String status;
    }
}