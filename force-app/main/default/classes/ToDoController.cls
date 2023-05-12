public with sharing class ToDoController {
    @AuraEnabled
    public static String addTodo(String payload){
        ToDo payloadObject = (ToDo) JSON.deserialize(payload, ToDo.class);

        SObject tsk = (SObject) Type.forName('ToDo__c').newInstance();
        tsk.put('Name', payloadObject.todoName);
        tsk.put('Done__c', payloadObject.done);

        insert tsk;

        return String.valueOf(tsk.Id);
    }

    @AuraEnabled
    public static void updateTodo(String payload){
        ToDo payloadObject = (ToDo) JSON.deserialize(payload, ToDo.class);
        
        SObject tsk = (SObject) Type.forName('ToDo__c').newInstance();
        tsk.put('Id', payloadObject.todoId);
        tsk.put('Name', payloadObject.todoName);
        tsk.put('Done__c', payloadObject.done);

        update tsk;
    }

    @AuraEnabled
    public static void deleteTodo(String todoId){
        SObject todo = (SObject) Type.forName('ToDo__c').newInstance();
        todo.put('Id', todoId);

        delete todo;
    }

    @AuraEnabled(cacheable=true)
    public static List<ToDo> getAllTodos(){
        List<SObject> todos = Database.query(
            'SELECT Id, Name, CreatedDate, Done__c FROM ToDo__c WHERE CreatedDate = LAST_N_DAYS:7 ORDER BY CreatedDate DESC'
        );

        return getToDos(todos);
    }

    @AuraEnabled
    public static List<ToDo> getCurrentTodos(){
        List<SObject> todos = Database.query(
         'SELECT Id, Name, CreatedDate, Done__c FROM ToDo__c WHERE CreatedDate = TODAY ORDER BY CreatedDate DESC'
        );

        return getToDos(todos);
    }

    @AuraEnabled
    public static List<ToDo> getToDos(List<SObject> objs){
        List<ToDo> todos = new List<ToDo>();

        for(SObject obj : objs){
            ToDo todo = new ToDo();
            todo.todoId = obj.Id;
            todo.todoName = String.valueOf(obj.get('Name'));
            todo.todoDate = Date.valueOf(obj.get('CreatedDate'));
            todo.done = Boolean.valueOf(obj.get('Done__c'));
            todos.add(todo);
        }

        return todos;
    }

    //Wrapper Class to represent a ToDo Item
    public class ToDo {
        @AuraEnabled
        public String todoId;
        @AuraEnabled
        public String todoName;
        @AuraEnabled
        public Date todoDate;
        @AuraEnabled
        public Boolean done;
  }

}