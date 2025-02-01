// src/TodoList.tsx
// after all the hastle this is the main chracter of the show, this is the file that will be used to create the to-do list.
import React, { useState } from 'react';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import './TodoList.css';

interface Todo {
  id: number;
  text: string;
}

interface TodoListProps {
  account: string;
}

const TodoList: React.FC<TodoListProps> = ({ account }) => {
  const [todos, setTodos] = useState<Todo[]>([]);
  const [newTodo, setNewTodo] = useState('');

  const addTodo = async () => {
    if (newTodo.trim() === '') return;
    const newTask = { id: Date.now(), text: newTodo.trim() };
    setTodos([...todos, newTask]);
    setNewTodo('');

    // Send the task to the backend to be saved, you can open the src/index.ts file to see the backend code and how are thing going there!
    const response = await fetch('http://localhost:3000/add-task', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ account, task: newTask }),
    });
    const result = await response.json();
    console.log(result);
  };

  const deleteTodo = (id: number) => {
    setTodos(todos.filter(todo => todo.id !== id));
  };

  return (
    <div className="TodoList">
      <h2>To-Do List</h2>
      <div className="todo-input">
        <input
          type="text"
          value={newTodo}
          onChange={(e) => setNewTodo(e.target.value)}
          placeholder="Add a new task"
        />
        <button onClick={addTodo}>Add</button>
      </div>
      <TransitionGroup component="ul" className="todo-list">
        {todos.map((todo) => (
          <CSSTransition key={todo.id} timeout={500} classNames="todo">
            <li>
              {todo.text}
              <button onClick={() => deleteTodo(todo.id)}>Delete</button>
            </li>
          </CSSTransition>
        ))}
      </TransitionGroup>
    </div>
  );
};

export default TodoList;
