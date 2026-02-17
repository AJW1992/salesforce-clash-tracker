
/*
 * NOTE: the Schedulable interface must be implemented as a top level class to avoid undefined behavior
 *      this may be blocked by the compiler in some platform versions but not by others
 */
public with sharing class ClashApiServiceSchedulable extends ClashApiService.Async implements Schedulable {
    public ClashApiServiceSchedulable(Types serviceType, List<String> tags) {
        super(serviceType, tags);
    }

    public void execute(SchedulableContext sc) {
        System.enqueueJob(new ClashApiService.Queued(this.serviceType, this.tags));
    }
}