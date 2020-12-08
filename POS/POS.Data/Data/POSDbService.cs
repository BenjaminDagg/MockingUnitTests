using Framework.Infrastructure.Data.Database;
using NPoco;
using NPoco.FluentMappings;
using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace POS.Infrastructure.Data
{
    public class POSDbService : IDbService
    {
        private bool _isChildQuery;

        /// <summary>
        /// Gets the database.
        /// </summary>
        public IDatabase Db { get; protected set; }

        /// <summary>
        /// Gets the transaction.
        /// </summary>
        public DbTransaction Transaction => Db?.Transaction;


        /// <summary>
        /// Unique instance Id used for logging and troubleshooting in multi-threaded applications
        /// </summary>
        public string InstanceId { get; }

        protected POSDbService(IDbConnectionInfo connectionInfo)
        {
            InstanceId = Guid.NewGuid().ToString();

            if (connectionInfo == null) return;
            var connectionStringName = connectionInfo.GetConnectionStringName();
            var connectionString = connectionInfo.GetConnectionString(connectionStringName);

            ConfigureDatabase(connectionString, connectionStringName);
        }


        /// <summary>
        /// Sets Transaction that has begun in a different service
        /// </summary>
        public virtual void SetTransactionContext(DbTransaction transaction)
        {
            Db.SetTransaction(transaction);

            _isChildQuery = true;
        }

        /// <summary>
        /// Begins a transaction 
        /// </summary>
        /// <param name="isolationLevel"></param>
        public virtual void BeginTransaction(IsolationLevel isolationLevel = IsolationLevel.ReadCommitted)
        {
            if (_isChildQuery) return;

            Db.BeginTransaction(isolationLevel);
        }
        /// <summary>
        /// Completes the transaction.
        /// </summary>
        public virtual void CompleteTransaction()
        {
            if (_isChildQuery || Transaction == null) return;
            Db.CompleteTransaction();
        }

        /// <summary>
        /// Aborts the transaction.
        /// </summary>
        public virtual void AbortTransaction()
        {
            if (_isChildQuery || Transaction == null) return;
            Db.AbortTransaction();
        }


        /// <summary>
        /// Performs a quick connection test to the database by running a simple select returning version or a common table
        /// </summary>
        /// <returns>true if success</returns>
        public virtual bool TestConnection()
        {
            const string timeoutMessage = "Connection timeout exceeded.";
            int timeoutSeconds = 2;
            try
            {
                const string sql = "SELECT @@@Version SqlVersion";

                Task t = Task.Factory.StartNew(() => Db.ExecuteScalar<string>(sql));

                if (!t.Wait(TimeSpan.FromMilliseconds(timeoutSeconds)))
                {
                    throw new Exception(timeoutMessage);
                }

            }
            catch (Exception ex)
            {

                var message = ex.Message.Contains(timeoutMessage)
                    ? " " + ex.Message
                    : "";

                throw new Exception("Unable to connect to database. " + message, ex);
            }

            return true;
        }

        /// <summary>
        /// Configures the database.
        /// </summary>
        /// <param name="connectionString">The connection string.</param>
        /// <param name="connectionName">Name of the connection.</param>
        /// <exception cref="System.InvalidOperationException">
        /// Unable to find database configuration with connectionName '{connectionName}'
        /// </exception>
        protected void ConfigureDatabase(string connectionString, string connectionName)
        {
            var dbFactory = DatabaseFactory.Config(x =>
            {
                //For other database engines (mysql, etc) this must be refactored
                x.UsingDatabase(() => new NPoco.Database(connectionString,
                    DatabaseType.SqlServer2012,
                    SqlClientFactory.Instance));

                var fluentConfig = FluentMappingConfiguration.Configure(new DgMappings());
                x.WithFluentConfig(fluentConfig);
            });

            Db = dbFactory.GetDatabase();
        }
    }
}