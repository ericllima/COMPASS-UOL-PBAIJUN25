"""
BookingUtils - Custom Python Library for Robot Framework
Provides utility functions for Restful Booker API testing
"""

import json
import random
from datetime import datetime, timedelta
from robot.api.deco import keyword


class BookingUtils:
    """Custom utilities for booking operations and data manipulation"""
    
    @keyword("Generate Random Booking Data")
    def generate_random_booking_data(self):
        """Generates random booking data for testing"""
        first_names = ["John", "Jane", "Alice", "Bob", "Charlie", "Diana"]
        last_names = ["Doe", "Smith", "Johnson", "Brown", "Wilson", "Davis"]
        
        checkin = datetime.now() + timedelta(days=random.randint(1, 30))
        checkout = checkin + timedelta(days=random.randint(1, 7))
        
        booking_data = {
            "firstname": random.choice(first_names),
            "lastname": random.choice(last_names),
            "totalprice": random.randint(100, 500),
            "depositpaid": random.choice([True, False]),
            "bookingdates": {
                "checkin": checkin.strftime("%Y-%m-%d"),
                "checkout": checkout.strftime("%Y-%m-%d")
            },
            "additionalneeds": random.choice(["Breakfast", "WiFi", "Parking", "Late checkout"])
        }
        
        return booking_data
    
    @keyword("Validate Booking Structure")
    def validate_booking_structure(self, booking_data):
        """Validates if booking data has required structure"""
        required_fields = ["firstname", "lastname", "totalprice", "depositpaid", "bookingdates"]
        required_date_fields = ["checkin", "checkout"]
        
        for field in required_fields:
            if field not in booking_data:
                raise AssertionError(f"Missing required field: {field}")
        
        if "bookingdates" in booking_data:
            for date_field in required_date_fields:
                if date_field not in booking_data["bookingdates"]:
                    raise AssertionError(f"Missing required date field: {date_field}")
        
        return True
    
    @keyword("Calculate Booking Duration")
    def calculate_booking_duration(self, checkin_date, checkout_date):
        """Calculates duration between checkin and checkout dates"""
        checkin = datetime.strptime(checkin_date, "%Y-%m-%d")
        checkout = datetime.strptime(checkout_date, "%Y-%m-%d")
        duration = (checkout - checkin).days
        return duration
    
    @keyword("Generate Test Report Data")
    def generate_test_report_data(self, test_results):
        """Generates formatted test report data"""
        total_tests = len(test_results)
        passed_tests = sum(1 for result in test_results if result.get("status") == "PASS")
        failed_tests = total_tests - passed_tests
        success_rate = (passed_tests / total_tests * 100) if total_tests > 0 else 0
        
        report = {
            "total_tests": total_tests,
            "passed_tests": passed_tests,
            "failed_tests": failed_tests,
            "success_rate": round(success_rate, 2),
            "timestamp": datetime.now().isoformat()
        }
        
        return report
    
    @keyword("Create Booking ID List")
    def create_booking_id_list(self, *booking_ids):
        """Creates a list of booking IDs for batch operations"""
        return list(booking_ids)
    
    @keyword("Filter Bookings By Price Range")
    def filter_bookings_by_price_range(self, bookings, min_price, max_price):
        """Filters bookings by price range"""
        filtered = []
        for booking in bookings:
            if isinstance(booking, dict) and "totalprice" in booking:
                price = booking["totalprice"]
                if min_price <= price <= max_price:
                    filtered.append(booking)
        return filtered
    
    @keyword("Convert JSON String To Dict")
    def convert_json_string_to_dict(self, json_string):
        """Converts JSON string to Python dictionary"""
        try:
            return json.loads(json_string)
        except json.JSONDecodeError as e:
            raise ValueError(f"Invalid JSON string: {e}")
    
    @keyword("Get Current Timestamp")
    def get_current_timestamp(self, format_string="%Y-%m-%d %H:%M:%S"):
        """Returns current timestamp in specified format"""
        return datetime.now().strftime(format_string)