@isTest
public with sharing class ToDoControllerTest {
    @TestSetup
    static void makeData(){
        List<SObject> todos = new List<SObject>();

        ToDo__c todo1 = new ToDo__c();
        todo1.Name = 'Teste 1';
        todo1.Done__c = false;

        ToDo__c todo2 = new ToDo__c();
        todo1.Name = 'Teste 2';
        todo1.Done__c = true;

        todos.add(todo1);
        todos.add(todo2);

        insert todos;

    }

    @isTest
    static void addTodoTest(){
        ToDoController.ToDo todo = new ToDoController.ToDo();
        todo.todoName = 'Teste 3';
        todo.done = false;
        Test.startTest();
        String payload = JSON.serialize(todo);
        ToDoController.addTodo(payload);
        Test.stopTest();
    }

    @isTest
    static void updateTodoTest(){
        ToDoController.ToDo todoUpdated = new ToDoController.ToDo();
        List<ToDo__c> todoList = new List<ToDo__c>();
        todoList = [SELECT Id FROM ToDo__c LIMIT 1];
        todoUpdated.todoId = todoList[0].id;
        todoUpdated.todoName = 'Teste 3';
        todoUpdated.done = false;
        Test.startTest();
        String payload = JSON.serialize(todoUpdated);
        ToDoController.updateTodo(payload);
        Test.stopTest();
    }

    @isTest
    static void deleteTodoTest(){
        List<Todo__c> todoToDelete = new List<Todo__c>();
        todoToDelete = [SELECT Id FROM ToDo__c WHERE Done__c = True LIMIT 1];
        Test.startTest();
        ToDoController.deleteTodo(todoToDelete[0].id);
        Test.stopTest();
    }

    @isTest 
    static void getAllTodosTest(){
        Test.startTest();
        ToDoController.getAllTodos();
        Test.stopTest();
    }

    @isTest
    static void getCurrentTodosTest(){
        Test.startTest();
        ToDoController.getCurrentTodos();
        Test.stopTest();
    }

/*     @isTest
    static void addTodoTest() {
      //create ToDo Object
      ToDoController.ToDo todo = new ToDoController.ToDo();
      todo.done = false;
      todo.todoName = 'Test todo 4';
      Test.startTest();
      String todoId = ToDoController.addTodo(JSON.serialize(todo));
      Test.stopTest();
  
      System.assert(todoId != null, 'Id is null');
  
      List<SObject> todos = Database.query(
        'SELECT Id, Name, CreatedDate, Done__c FROM ToDo__c'
      );
      System.assertEquals(3, todos.size(), 'Todos size should be 3');
    } */
        
    
}