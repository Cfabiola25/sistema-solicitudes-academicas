package util;

import java.time.DayOfWeek;
import java.time.LocalDateTime;

/**
 * Utility class for SLA calculations.
 * Supports calendar days and custom working days (excluding Saturday, Sunday, and Monday).
 */
public class SLACalculator {

    /**
     * Calculates the deadline date based on a starting date, response time in days, and time type.
     * 
     * @param start the request submission date
     * @param days the response time (SLA) in days
     * @param type the type of days: "habiles" or "calendario"
     * @return the deadline date and time
     */
    public static LocalDateTime calculateDeadline(LocalDateTime start, int days, String type) {
        if (start == null) {
            return null;
        }
        
        if ("calendario".equalsIgnoreCase(type)) {
            return start.plusDays(days);
        } else {
            // "habiles" - exclude Saturday, Sunday, and Monday.
            // Working days are Tuesday, Wednesday, Thursday, Friday.
            LocalDateTime current = start;
            int addedDays = 0;
            while (addedDays < days) {
                current = current.plusDays(1);
                DayOfWeek dow = current.getDayOfWeek();
                if (dow != DayOfWeek.SATURDAY && dow != DayOfWeek.SUNDAY && dow != DayOfWeek.MONDAY) {
                    addedDays++;
                }
            }
            return current;
        }
    }
}
