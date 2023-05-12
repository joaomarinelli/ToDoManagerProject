import { LightningElement, api } from 'lwc';
import updateTodo from '@salesforce/apex/ToDoController.updateTodo';
import deleteTodo from '@salesforce/apex/ToDoController.deleteTodo';

export default class ToDoItem extends LightningElement {
    @api todoId;
    @api todoName;
    @api done = false;

    updateHandler(){
        const todo = {
            todoId: this.todoId,
            todoName: this.todoName,
            done : !this.done
        };

        updateTodo({payload : JSON.stringify(todo)})
        .then(result => {
            console.log("Item updated");
            const updateEvent = new CustomEvent("update", { detail: todo });
            this.dispatchEvent(updateEvent);
        }).catch(error => {
            console.log("Error in update" , error);
        });
    }

    deleteHandler(){
        deleteTodo({todoId : this.todoId})
        .then(result => {
            console.log("Deleted item successfully");
            this.dispatchEvent(new CustomEvent("delete", { detail: this.todoId }));
        }).catch(error => {
            console.log("Error to delete item ", error);
        });
    }

    get containerClass(){
        return this.done ? "todo completed" : "todo upcoming";
    }

    get iconName(){
        return this.done ? "utility:check" : "utility:add"
    }


}