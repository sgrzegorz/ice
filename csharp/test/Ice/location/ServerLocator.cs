//
// Copyright (c) ZeroC, Inc. All rights reserved.
//

using System.Diagnostics;
using System.Threading.Tasks;

namespace Ice
{
    namespace location
    {
        public class ServerLocator : Test.TestLocator
        {
            public ServerLocator(ServerLocatorRegistry registry, Ice.ILocatorRegistryPrx registryPrx)
            {
                _registry = registry;
                _registryPrx = registryPrx;
                _requestCount = 0;
            }

            public Task<Ice.IObjectPrx>
            FindAdapterByIdAsync(string adapter, Ice.Current current)
            {
                ++_requestCount;
                if (adapter.Equals("TestAdapter10") || adapter.Equals("TestAdapter10-2"))
                {
                    Debug.Assert(current.Encoding.Equals(Util.Encoding_1_0));
                    return Task.FromResult(_registry.getAdapter("TestAdapter"));
                }
                else
                {
                    // We add a small delay to make sure locator request queuing gets tested when
                    // running the test on a fast machine
                    System.Threading.Thread.Sleep(1);
                    return Task.FromResult(_registry.getAdapter(adapter));
                }
            }

            public Task<Ice.IObjectPrx>
            FindObjectByIdAsync(Ice.Identity id, Ice.Current current)
            {
                ++_requestCount;
                // We add a small delay to make sure locator request queuing gets tested when
                // running the test on a fast machine
                System.Threading.Thread.Sleep(1);
                return Task.FromResult(_registry.getObject(id));
            }

            public Ice.ILocatorRegistryPrx GetRegistry(Ice.Current current)
            {
                return _registryPrx;
            }

            public int getRequestCount(Ice.Current current)
            {
                return _requestCount;
            }

            private ServerLocatorRegistry _registry;
            private Ice.ILocatorRegistryPrx _registryPrx;
            private int _requestCount;
        }
    }
}
