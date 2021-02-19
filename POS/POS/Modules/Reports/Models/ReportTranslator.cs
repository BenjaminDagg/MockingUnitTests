using POS.Core.Reports;
using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Modules.Reports.Models
{
    public static class ReportTranslator
    {
        public static Report Translate(ReportDto reportDto)
        {
            if(reportDto == null)
            {
                return null;
            }

            return new Report
            {
                Name = reportDto.Name,
                LastRun = reportDto.LastRun
            };
        }

        public static ReportDto Translate(Report report)
        {
            if (report == null)
            {
                return null;
            }

            return new ReportDto
            {
                Name = report.Name,
                LastRun = report.LastRun
            };
        }
    }
}
