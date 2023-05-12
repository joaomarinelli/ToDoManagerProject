import { LightningElement, track } from 'lwc';
import addTodo from '@salesforce/apex/ToDoController.addTodo';
import getAllTodos from '@salesforce/apex/ToDoController.getAllTodos';
import getCurrentTodos from '@salesforce/apex/ToDoController.getCurrentTodos';

export default class ToDoManager extends LightningElement {
    @track time = "11PM";
    @track greeting = "Boa Noiteeeee"; 
    @track todos = [];

    connectedCallback(){
        this.getTime();
        this.fetchTodos();

        setInterval(() => {
            this.getTime();
        }, 1000)
    }
    
    
    getTime() {
        const date = new Date();
        const hour = date.getHours();
        const min = date.getMinutes();
    
        this.time = `${this.getHour(hour)}:${this.getDoubleDigit(
          min
        )}`;
        this.setGreeting(hour);
    }

    getHour(hour){
        return hour;
    }

    getMidDay(hour){
        return hour >= 12 ? "PM" : "AM";
    }

    getDoubleDigit(digit){
        return digit <10 ? "0"+digit : digit;
    }

    setGreeting(hour){
        if(hour < 12){
            this.greeting = "Bom Dia!";
        }else if(hour >= 12 && hour < 18){
            this.greeting = "Boa Tarde!";
        }else{
            this.greeting = "Boa Noite!";
        }

    }

    addTodoHandler(){
        const inputBox = this.template.querySelector('lightning-input');
        console.log("current value: ", inputBox.value);
        const todo = {
            todoName : inputBox.value,
            done : false
        };

        addTodo({payload : JSON.stringify(todo)})
        .then(result => {
            if(result){
                console.log(('Item inserted successfully'));
                this.fetchTodos();
            }

        })
        .catch(error => {
            console.log('Error in inserting todo item ' + error);
        });
        //this.todos.push(todo);
        inputBox.value = "";
    }



    fetchTodos(){
        getCurrentTodos().then(result => {
            if(result){
            console.log("Retrived todos from server ", result.length);
            this.todos = result;
            }
        }).catch(error => {
            console.log('Error in fetching todos ' + error);
        });
    }

    updateTodoHandler() {
        console.log("PAssei aqui no fetch do update");
        this.fetchTodos();
    }

    deleteTodoHandler() {
        this.fetchTodos();
    }

    get upcomingTasks(){
        return this.todos && this.todos.length ? this.todos.filter( todo => !todo.done) : [];
    }

    get completedTasks(){
        return this.todos && this.todos.length ? this.todos.filter( todo => todo.done) : [];
    }


}
