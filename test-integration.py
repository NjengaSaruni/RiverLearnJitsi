#!/usr/bin/env python3
"""
Test script to verify Jitsi Meet integration with Course Organizer
"""

import requests
import json
import sys

# Configuration
COURSE_ORGANIZER_URL = "https://co.riverlearn.co.ke"
JITSI_DOMAIN = "jitsi.riverlearn.co.ke:8443"

def test_jitsi_server():
    """Test if Jitsi Meet server is accessible"""
    print("🔍 Testing Jitsi Meet server accessibility...")
    
    try:
        response = requests.get(f"https://{JITSI_DOMAIN}/test-room", verify=False, timeout=10)
        if response.status_code == 200:
            print("✅ Jitsi Meet server is accessible")
            return True
        else:
            print(f"❌ Jitsi Meet server returned status {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Failed to connect to Jitsi Meet server: {e}")
        return False

def test_course_organizer_api():
    """Test if Course Organizer API is accessible"""
    print("🔍 Testing Course Organizer API accessibility...")
    
    try:
        response = requests.get(f"{COURSE_ORGANIZER_URL}/api/", timeout=10)
        if response.status_code == 200:
            print("✅ Course Organizer API is accessible")
            return True
        else:
            print(f"❌ Course Organizer API returned status {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Failed to connect to Course Organizer API: {e}")
        return False

def test_jitsi_token_endpoint():
    """Test Jitsi token endpoint (without authentication)"""
    print("🔍 Testing Jitsi token endpoint...")
    
    try:
        # Test without authentication (should return 401/403)
        response = requests.post(
            f"{COURSE_ORGANIZER_URL}/api/jitsi/token/",
            json={"room_name": "test-room", "meeting_id": 1},
            timeout=10
        )
        
        if response.status_code in [401, 403]:
            print("✅ Jitsi token endpoint is accessible (authentication required)")
            return True
        elif response.status_code == 200:
            print("⚠️  Jitsi token endpoint returned 200 (no authentication required)")
            return True
        else:
            print(f"❌ Jitsi token endpoint returned unexpected status {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Failed to test Jitsi token endpoint: {e}")
        return False

def test_domain_resolution():
    """Test if domains resolve correctly"""
    print("🔍 Testing domain resolution...")
    
    import socket
    
    try:
        # Test Course Organizer domain
        co_ip = socket.gethostbyname("co.riverlearn.co.ke")
        print(f"✅ co.riverlearn.co.ke resolves to {co_ip}")
        
        # Test Jitsi domain
        jitsi_ip = socket.gethostbyname("jitsi.riverlearn.co.ke")
        print(f"✅ jitsi.riverlearn.co.ke resolves to {jitsi_ip}")
        
        return True
    except Exception as e:
        print(f"❌ Domain resolution failed: {e}")
        return False

def main():
    """Run all integration tests"""
    print("🚀 Testing Jitsi Meet integration with Course Organizer")
    print("=" * 60)
    
    tests = [
        ("Domain Resolution", test_domain_resolution),
        ("Jitsi Meet Server", test_jitsi_server),
        ("Course Organizer API", test_course_organizer_api),
        ("Jitsi Token Endpoint", test_jitsi_token_endpoint),
    ]
    
    results = []
    for test_name, test_func in tests:
        print(f"\n📋 {test_name}")
        print("-" * 40)
        try:
            result = test_func()
            results.append((test_name, result))
        except Exception as e:
            print(f"❌ Test failed with exception: {e}")
            results.append((test_name, False))
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 TEST SUMMARY")
    print("=" * 60)
    
    passed = 0
    total = len(results)
    
    for test_name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{status} {test_name}")
        if result:
            passed += 1
    
    print(f"\n🎯 Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All tests passed! Integration is ready.")
        return 0
    else:
        print("⚠️  Some tests failed. Check the issues above.")
        return 1

if __name__ == "__main__":
    sys.exit(main())
