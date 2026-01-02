using JET, SimpleOptimization, Test

@testset "JET static analysis" begin
    # Test that the package passes JET analysis without errors
    @testset "Package-level analysis" begin
        result = JET.report_package("SimpleOptimization")
        reports = JET.get_reports(result)
        # Filter out any reports about external packages
        pkg_reports = filter(reports) do report
            # Only consider reports from SimpleOptimization files
            occursin("SimpleOptimization", string(report.vst[1].file))
        end
        @test length(pkg_reports) == 0
    end
end
