using Microsoft.VisualStudio.TestTools.UnitTesting;
using POS.Core.ValueObjects;

namespace POS.Test
{
    [TestClass]
    public class TestMoney
    {
        [TestMethod]
        public void TestAddMoney()
        {

            var m1 = Money.Create(1).Value;
            var m2 = Money.Create(1).Value;
            var r = m1 + m2;
            Assert.IsTrue( r == 2);

        }
    }
}
