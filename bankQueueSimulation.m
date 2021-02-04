% clear
clear;
clc;

total_clients = 500;                  % number of clients

% system parameters
k = 2;                              
queue_lim = 200000;                 %  limit of queues
service_mean_time_1=6;              % miu 1
service_mean_time_2=15;             % miu 2
arrival_mean_time=3;                % lamda
j=1;    
total_time = 0.0;
last_event_time=0.0;
server_status(1:4) = 0;                 
num_server_busy=0;
server_1(j)=0;
server_2(j)=0;
server_3(j)=0;
server_4(j)=0;
time(j)=1;
num_clients_count=0;                   
num_clients_in_queue_2=0;           %number of clients in queue 2
num_clients_in_queue_1=0;           %number of clients in queue 1
num_clients_count_queue_1=0;
num_clients_count_queue_2=0;
    
time_in_queue_2=0.0;
time_in_queue_1=0.0;
time_in_server=0.0;
    
    
    % next
next_exit_event_time(1:4) = exp(30);   % ye meghdare bala bara mot ma en shodan az rooy nadadan
        
    disp(['Dar hale shabih sazi...']);
    
    while(num_clients_count < total_clients)
        
        arrival_mean_time=3+ floor((rand*2*((-1)^floor(rand*3))));     
        next_event_min_time = exp(29);
        % event arrival baadi
        time_pishamde_arrival_baadi = total_time +arrival_mean_time;

        % 0 when there is no events ; -1 for arrival event; i>0 for exit event from server i
        event_type = 0;
        
        if (time_pishamde_arrival_baadi < next_event_min_time)
            next_event_min_time = time_pishamde_arrival_baadi;
            event_type = -1; % event arrival  
        end
        
        for i=1:4
            if(next_exit_event_time(i) < min_timeevent_baadi)
                next_event_min_time = next_exit_event_time(i);
                event_type = i; % exit from server i event
            end;
        end
        
        if(event_type == 0)
            disp(['There is no event ',num2str(total_time)]);
        end
        
        % time values update 
        total_time = next_event_min_time;
        time_az_akharin_event = total_time - last_event_time;
        last_event_time = total_time;
        
        time_in_queue_2 = time_dar_queue_2 + num_clients_in_queue_2 * time_az_akharin_event ;
        time_dar_queue_1 = time_dar_queue_1 + num_clients_in_queue_1 * time_az_akharin_event ;
        
        time_in_server = time_in_server + num_server_busy * time_az_akharin_event;
        
        
        if (event_type == -1)
            % --------------------- arrival --------------------------
            num_clients_count = num_clients_count + 1;
            time_pishamde_arrival_baadi = total_time + arrival_mean_time;
            A = (server_status(1) ==1 & server_status(2)==1) ;
            B = (server_status(3) ==1 & server_status(4)==1);
          if ( rand< 0.67 ) % it means that the customer is public
            if(A == true) %yani hardo server e baje omoomi por ast va moshtari bayad too saf beravad
                                
                num_clients_in_queue_1 = num_clients_in_queue_1 + 1 ;
                num_clients_count_queue_1 = num_clients_count_queue_1 + 1;
                if(num_clients_in_queue_1 > queue_lim)
                    disp(['queue_2 size = ', num2str(num_clients_in_queue_1)]);
                    disp(['System Crash at ',num2str(total_time)]);
                    pause
                end
                
            else
                num_server_busy = num_server_busy + 1;
                
                empty_servers = find(server_status == 0);
                empty_servers = empty_servers(randperm(length(empty_servers)));
                server_status(empty_servers(1)) = 1;
                next_exit_event_time(empty_servers(1)) = total_time + service_mean_time_1+floor((rand*6*((-1)^floor(rand*10))));
            
            end          
          else
            if(B == true)
                
                num_clients_in_queue_2 = num_clients_in_queue_2 + 1 ;
                num_clients_count_queue_2 = num_clients_count_queue_2 + 1;
                
                if(num_clients_in_queue_2 > queue_lim)
                    disp(['queue_2 size = ', num2str(num_clients_in_queue_2)]);
                    disp(['System Crash at ',num2str(total_time)]);
                    pause
                end
                
            else
                num_server_busy = num_server_busy + 1;
                
                empty_servers = find(server_status == 0);
                empty_servers = empty_servers(randperm(length(empty_servers)));
                server_status(empty_servers(1)) = 1;
                next_exit_event_time(empty_servers(1)) = total_time + service_mean_time_2+floor((rand*11*((-1)^floor(rand*10))));
            end
          end
            
        elseif (event_type > 0)
            % ---------------------- exit -----------------------
            server_status(event_type) = 0;
            next_exit_event_time(event_type) = exp(30);
          if (event_type) < 3 %yani safe 1 (omoomi)
            if(num_clients_in_queue_1 == 0)
                num_server_busy = num_server_busy - 1;                
            else
                num_clients_in_queue_1 = num_clients_in_queue_1 - 1;

                empty_servers = find(server_status == 0);
                empty_servers = empty_servers(randperm(length(empty_servers)));
                server_status(empty_servers(1)) = 1;
                next_exit_event_time(empty_servers(1)) = total_time + service_mean_time_1;
            end
          else %yani safe 2 (tejari)
            if(num_clients_in_queue_2 == 0)
                num_server_busy = num_server_busy - 1;                
            else
                num_clients_in_queue_2 = num_clients_in_queue_2 - 1;

                empty_servers = find(server_status == 0);
                empty_servers = empty_servers(randperm(length(empty_servers)));
                server_status(empty_servers(1)) = 1;
                next_exit_event_time(empty_servers(1)) = total_time + service_mean_time_2;
            end
          end
        end
              if(server_status(1) == 0)
                server_1(j)=0;
              else
                server_1(j)=1;  
              end
              if(server_status(2) == 0)
                server_2(j)=0;
              else
                server_2(j)=1;
              end
              if(server_status(3) == 0)
                server_3(j)=0;
              else
                server_3(j)=1;                
              end              
              if(server_status(4) == 0)
                server_4(j)=0;
              else
                server_4(j)=1;                
              end
                
    %natayeje exit
     queue_2(j)= num_clients_in_queue_2;
     queue_1(j)= num_clients_in_queue_1;     
     time(j)=total_time;
     j=j+1;
    end
     avg_num_in_queue_2 = time_dar_queue_2/total_time;
     avg_delay_in_queue_2 = time_dar_queue_2/num_clients_count_queue_2;
     avg_num_in_queue_1 = time_dar_queue_1/total_time;
     avg_delay_in_queue_1 = time_dar_queue_1/num_clients_count_queue_1;
    disp(['Average numbers in Commercial queue:',num2str(avg_num_in_queue_2)]);
    disp(['Average delay in Commercial queue:',num2str(avg_delay_in_queue_2)]);
    disp(['Average numbers in the Publlic queue:',num2str(avg_num_in_queue_1)]);
    disp(['Average delay in the Public queue:',num2str(avg_delay_in_queue_1)]);    
%----------------------graphs--------------------------------
figure();
plot(time,server_3);
title(['Server 3 (Commercial) Clients in Time']);
xlabel('Time');
ylabel('number of clients');
axis([0 1000 0 2]);

figure();
plot(time,server_4);
title(['Server 4 (Commercial) Clients in Time']);
xlabel('Time');
ylabel('number of clients');
axis([0 1000 0 2]);

figure();
plot(time,queue_2);
title(['Number of(Commercial) Queue']);
xlabel('Time');
ylabel('number of clients');
axis([0 1000 0 10]);


figure();
plot(time,server_1);
title(['Server 1 (Public) Clients in Time']);
xlabel('Time');
ylabel('number of clients');
axis([0 1000 0 2]);

figure();
plot(time,server_2);
title(['Server 2 (Public) Clients in Time']);
xlabel('Time');
ylabel('number of clients');
axis([0 1000 0 2]);

figure();
plot(time,queue_1);
title(['Number of (Public) Queue']);
xlabel('Time');
ylabel('number of clients');
axis([0 1000 0 10]);
