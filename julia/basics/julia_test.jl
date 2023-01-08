#! /usr/bin/env julia
# https://stackoverflow.com/a/74077856
function f()
    N=1000
    T=20
    sdt=1
    base=fill(1,N)
    mb=collect(1:N)
    time_data = fill(0,floor(Int, T/sdt))

    function run(kp,km)
        fill!(base, 1)
        mb .= 1:N
        fill!(time_data, 0)
        m=N
        th=0
        time_data[1]=N
        time_temp = sdt

        @inbounds while th<T
            # println(th, ' ', m)
            if m==0
                println(th)
                break
            end

            if th>time_temp
                time_data[ceil(Int, time_temp/sdt)+1]=m
                time_temp += sdt
            end

            kt=m*(kp+km)
            th=th+rand(Exponential(1/kt))
            ran=kt*rand(Float64)
            index=floor(Int,ran/(kp+km))
            rem=ran-index*(kp+km)
            index=index+1

            if rem<km
                base[mb[index]]=0
                tmp=mb[index]
                mb[index]=mb[m]
                mb[m]=tmp
                m=m-1
            else
                pos=rand(1:N)
                if base[pos]==0
                    base[pos]=1
                    mb[m+1]=pos
                    m=m+1
                end
            end

        end
        return time_data
    end

    function sample(num_runs)
        time_data_avg = fill(0.0, floor(Int, T/sdt))
        td_var=fill(0.0, floor(Int, T/sdt))
        for i in 1:num_runs
            m = run(2,1)
            time_data_avg .+= m ./ num_runs
            td_var .+= m.*(m ./ num_runs)
        end
        td_var .-= time_data_avg.^2

        return time_data_avg, td_var
    end

    @time begin
        tm,tv=sample(1000)
    end
end


