module Actions
  module ForemanGutterball
    module ContentReports
      class Report < Actions::EntryAction
        def plan(report_type, params)
          plan_self(:report_type => report_type, :params => params)
        end

        def run
          service = ::ForemanGutterball::GutterballService.new
          output[:report_data] = service.report(input[:report_type], input[:params])
        end
      end
    end
  end
end
