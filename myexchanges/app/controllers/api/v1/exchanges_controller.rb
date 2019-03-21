module Api
  module V1
    class ExchangesController < ApplicationController
      def index
        exchanges = Exchange.order('date DESC');
        render json: {status: 'SUCCESS', message:'Loaded Exchanges', data:exchanges}, status: :ok
      end

      def show
        exchanges = Exchange.order('date DESC');
        result = Array.new()
        for item in exchanges
          arr = Array.new()
          if item[:date].to_s.eql?(params[:id].to_s)
            arr.append(item)
            average = average(item[:from], item[:to], item[:date], exchanges)
            variance = variance(item[:from], item[:to], item[:date], exchanges)
            history = history(item[:from], item[:to], item[:date], exchanges)
            arr.append(average)
            arr.append(variance)
            arr.append(history)
            result.append(arr)
          end
        end
        render json: {status: 'SUCCESS', message:'Loaded Exchanges', data:result}, status: :ok
      end

      def create
        exchange = Exchange.new(exchange_params)
        if exchange.save
          render json: {status: 'SUCCESS', message:'Saved Exchanges', data:exchange}, status: :ok
        else
          render json: {status: 'SUCCESS', message:'Exchanges not saved', data:exchange.errors}, status: :unprocessable_entity
        end
      end

      def destroy
        exchanges = Exchange.order('date DESC');
        prm = params[:id].split("@")
        date = prm[0]
        from = prm[1]
        to = prm[2]
        for item in exchanges
          if item[:date].to_s.eql?(params[:id].to_s) and item[:from].eql?(from) and item[:to].eql?(to)
            item.destroy
          end
        end
        render json: {status: 'SUCCESS', message:'Deleted Exchanges', data:result}, status: :ok
      end

      def update
        exchange = Exchange.find(params[:id])
        if exchange.update_attributes(exchange_params)
          render json: {status: 'SUCCESS', message:'Updated Exchanges', data:exchange}, status: :ok
        else
          render json: {status: 'SUCCESS', message:'Exchanges not updated', data:exchange.errors}, status: :unprocessable_entity
        end
      end

      private

      def exchange_params
        params.permit(:date, :from, :to, :rate)
      end

      def average(from, to, date, exchanges)
        arr = Array.new()
        newarr = Array.new()
        for item in exchanges
          if item[:from].eql?(from) and item[:to].eql?(to)
            arr.append(item)
          end
        end
        limit = date - 7
        for item in arr
          if item[:date] > limit
            newarr.append(item)
          else
            break
          end
        end

        sum = 0
        counter = 0
        for item in newarr
          if !item[:rate].nil?
            sum += item[:rate]
            counter += 1
          end
        end
        if counter != 7
          return -1
        else
          return sum/counter
        end
      end

      def variance(from, to, date, exchanges)
        arr = Array.new()
        newarr = Array.new()
        for item in exchanges
          if item[:from].eql?(from) and item[:to].eql?(to)
            arr.append(item)
          end
        end
        limit = date - 7
        for item in arr
          if item[:date] > limit
            newarr.append(item)
          else
            break
          end
        end

        max = 0
        min = 3
        counter = 0
        for item in newarr
          if !item[:rate].nil?
            if item[:rate] > max
              max = item[:rate]
            end
            if item[:rate] < min
              min = item[:rate]
            end
            counter += 1
          end
        end
        if counter != 7
          return -1
        else
          return max-min
        end
      end

      def history(from, to, date, exchanges)
        arr = Array.new()
        newarr = Array.new()
        for item in exchanges
          if item[:from].eql?(from) and item[:to].eql?(to)
            arr.append(item)
          end
        end
        limit = date - 7
        for item in arr
          if item[:date] > limit
            newarr.append(item)
          else
            break
          end
        end
        return newarr
      end

    end
  end
end
