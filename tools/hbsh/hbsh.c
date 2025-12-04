#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

#define MAX_COMMAND_LENGTH 1024
#define MAX_ARGS 128

void print_help() {
    printf("HubbleOS Shell (hbsh) - Comandos disponíveis:\n");
    printf("  cd <dir>      - Muda o diretório\n");
    printf("  pwd           - Mostra diretório atual\n");
    printf("  help          - Mostra esta mensagem\n");
    printf("  exit          - Sai do shell\n");
    printf("  <comando>     - Executa um comando do sistema\n");
}

void execute_command(char **args) {
    if (args[0] == NULL) return;
    
    // Builtin: cd
    if (strcmp(args[0], "cd") == 0) {
        if (args[1] == NULL) {
            chdir(getenv("HOME"));
        } else {
            if (chdir(args[1]) != 0) {
                perror("cd");
            }
        }
        return;
    }
    
    // Builtin: pwd
    if (strcmp(args[0], "pwd") == 0) {
        char cwd[1024];
        if (getcwd(cwd, sizeof(cwd)) != NULL) {
            printf("%s\n", cwd);
        } else {
            perror("pwd");
        }
        return;
    }
    
    // Builtin: help
    if (strcmp(args[0], "help") == 0) {
        print_help();
        return;
    }
    
    // Builtin: exit
    if (strcmp(args[0], "exit") == 0) {
        exit(0);
    }
    
    // Execute external command
    pid_t pid = fork();
    if (pid == 0) {
        // Child process
        if (execvp(args[0], args) == -1) {
            perror(args[0]);
            exit(1);
        }
    } else if (pid > 0) {
        // Parent process - wait for child
        int status;
        waitpid(pid, &status, 0);
    } else {
        perror("fork");
    }
}

int main() {
    char command[MAX_COMMAND_LENGTH];
    char *args[MAX_ARGS];
    char cwd[1024];
    
    printf("HubbleOS Shell (hbsh) v1.0\n");
    printf("Digite 'help' para uma lista de comandos\n\n");
    
    while (1) {
        // Print prompt
        if (getcwd(cwd, sizeof(cwd)) != NULL) {
            printf("hbsh:%s$ ", cwd);
        } else {
            printf("hbsh:?$ ");
        }
        fflush(stdout);
        
        // Read command
        if (fgets(command, MAX_COMMAND_LENGTH, stdin) == NULL) {
            break;
        }
        
        // Remove newline
        command[strcspn(command, "\n")] = 0;
        
        if (strlen(command) == 0) continue;
        
        // Parse command
        int argc = 0;
        char *cmd_copy = malloc(strlen(command) + 1);
        strcpy(cmd_copy, command);
        
        char *token = strtok(cmd_copy, " ");
        while (token != NULL && argc < MAX_ARGS - 1) {
            args[argc] = malloc(strlen(token) + 1);
            strcpy(args[argc], token);
            argc++;
            token = strtok(NULL, " ");
        }
        args[argc] = NULL;
        free(cmd_copy);
        
        // Execute command
        execute_command(args);
        
        // Free args
        for (int i = 0; i < argc; i++) {
            free(args[i]);
        }
    }
    
    return 0;
}
