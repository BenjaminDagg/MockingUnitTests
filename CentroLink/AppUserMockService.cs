using System;
using Framework.Infrastructure.Identity.Domain;
using Framework.Infrastructure.Identity.Domain;

namespace Framework.Tests
{
    public class AppUserMockService
    {
        private AppUserDbContext _context;

        public AppUserMockService(AppUserDbContext context)
        {
            _context = context;
        }

        public AppUser AddUser(string username, string password)
        {

        }
    }
}

